//
//  ReplyTweetView.swift
//  Timeline
//
//  Created by amos.gyamfi@getstream.io on 15.03.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI
import Profile
import Auth
import PhotosUI
import os.log

import Feeds

//let logger = Logger(subsystem: "ReplyTweetView", category: "main")

public struct ReplyTweetView: View {
    @EnvironmentObject var feedsClient: FeedsClient
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isShowingComposeArea = ""
    @State private var isRecording = false
    @State private var isShowingUser = false
    
    @State var selectedItems: [PhotosPickerItem] = []
    @State var selectedPhotosData = [Data]()
    
    var profileInfoViewModel: ProfileInfoViewModel
    
    public init(profileInfoViewModel: ProfileInfoViewModel) {
        self.profileInfoViewModel = profileInfoViewModel
    }
    
    public var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "line.diagonal")
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(-45))
                    HStack {
                        Text("Replying to ").font(.caption).foregroundColor(.secondary)
                        Button {
                            self.isShowingUser.toggle()
                        } label: {
                            Text("@jeroenL")
                                .font(.caption)
                                .bold()
                    }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .sheet(isPresented: $isShowingUser) {
                    ReplyingToView()
                        .presentationDetents([.fraction(0.5)])
                }
                
                HStack(alignment: .top) {
                    
                    ProfileImage(imageUrl: profileInfoViewModel.feedUser?.profilePicture, action: {})
                    TextField("Tweet your reply", text: $isShowingComposeArea, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3, reservesSpace: true)
                        .font(.caption)
                        .keyboardType(.twitter)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        AsyncButton("Tweet") {
                            do {
                                var tweetPhotoUrlString: String?
                                logger.debug("add tweet photo identifier: \(selectedItems.first?.itemIdentifier ?? "", privacy: .public)")
                                
                                if let item = selectedItems.first, let mimeType = item.supportedContentTypes.first?.preferredMIMEType, let imageData = selectedPhotosData.first {
                                    
                                    tweetPhotoUrlString = try await feedsClient.uploadImage(fileName: item.itemIdentifier ?? "filename", mimeType: mimeType, imageData: imageData).absoluteString
                                    logger.debug("add tweet photo url: \(tweetPhotoUrlString ?? "", privacy: .public)")
                                    
                                }
                                
                                let activity = PostActivity(actor: feedsClient.authUser.userId, object: isShowingComposeArea, tweetPhotoUrlString: tweetPhotoUrlString)
                                try await feedsClient.addActivity(activity)
                                presentationMode.wrappedValue.dismiss()
                            } catch {
                                print(error)
                            }
                            
                            print("tap to send tweet")
                        }
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .buttonStyle(.borderedProminent)
                        .disabled(isShowingComposeArea.isEmpty)
                    }
                    
                    // Photo picker view
                    ToolbarItem(placement: .keyboard) {
                        Button {
                            print("tap to upload an image")
                        } label: {
                            VStack {
                                PhotosPicker(
                                    selection: $selectedItems,
                                    maxSelectionCount: 1,
                                    matching: .any(of: [.images, .not(.livePhotos)])
                                ) {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .accessibilityLabel("Photo picker")
                                        .accessibilityAddTraits(.isButton)
                                }
                                .onChange(of: selectedItems) { newItems in
                                    selectedPhotosData.removeAll()
                                    for newItem in newItems {
                                        Task {
                                            if let data = try? await newItem.loadTransferable(type: Data.self) {
                                                selectedPhotosData.append(data)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .keyboard) {
                        Button {
                            print("tap to initiate a new Space")
                        } label: {
                            Image(systemName: "mic.badge.plus")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        
                    }
                    
                    ToolbarItem(placement: .keyboard) {
                        Button {
                            self.isRecording.toggle()
                        } label: {
                            Image(systemName: "waveform")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        .fullScreenCover(isPresented: $isRecording) {
                            RecordAudioView(profileInfoViewModel: profileInfoViewModel)
                        }
                    }
                    
                    ToolbarItem(placement: .keyboard) {
                        Button {
                            print("tap to record audio")
                        } label: {
                            Image(systemName: "bolt.square")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                    }
                    
                    // For the sake of keeping the 4 above icons on the left of the keyboard
                    ToolbarItem(placement: .keyboard) {
                        Button {
                            print("tap to record audio")
                        } label: {
                            Image(systemName: "")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                    }
                }
                ForEach(selectedPhotosData, id: \.self) { photoData in
                    if let image = UIImage(data: photoData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10.0)
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ReplyTweetView_Previews: PreviewProvider {
    static var previews: some View {
        ReplyTweetView(profileInfoViewModel: ProfileInfoViewModel())
            .preferredColorScheme(.dark)
    }
}
