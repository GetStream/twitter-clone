//
//  AddNewTweetView.swift
//  Timeline
//
//  Created by amos.gyamfi@getstream.io on 26.1.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI
import Profile
import Auth
import PhotosUI
import os.log

import Feeds

let logger = Logger(subsystem: "AddNewTweetView", category: "main")

public struct AddNewTweetView: View {
    @EnvironmentObject var feedsClient: FeedsClient
    @StateObject
    var auth: TwitterCloneAuth
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var composeAreaIsFocussed: Bool
    
    @State private var isShowingComposeArea = ""
    @State private var isRecording = false
    
    @State var selectedItems: [PhotosPickerItem] = []
    @State var selectedPhotosData = [Data]()
    
    @StateObject var cameraViewModel: CameraViewModel
    
    var profileInfoViewModel: ProfileInfoViewModel
    
    public init(profileInfoViewModel: ProfileInfoViewModel, auth: TwitterCloneAuth) {
        self.profileInfoViewModel = profileInfoViewModel
        _auth = StateObject(wrappedValue: auth)
        _cameraViewModel = StateObject(wrappedValue: CameraViewModel(auth: auth))
    }
    
    public var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    
                    ProfileImage(imageUrl: profileInfoViewModel.feedUser?.profilePicture, action: {})
                    TextField("What's happening?", text: $isShowingComposeArea, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3, reservesSpace: true)
                        .font(.caption)
                        .keyboardType(.twitter)
                        .focused($composeAreaIsFocussed)
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
                                var tweetMovieAssetId: String?
                                var tweetMoviePlaybackId: String?

                                if let muxUploadId = cameraViewModel.muxUploadId {
                                    do {
                                        let response = try await auth.muxAssetId(uploadId: muxUploadId)
                                        tweetMovieAssetId = response.asset_id
                                        if let tweetMovieAssetId {
                                            let playbackResponse = try? await auth.muxPlaybackId(assetId: tweetMovieAssetId)
                                            tweetMoviePlaybackId = playbackResponse?.ids.first?.id
                                        }
                                    } catch {
                                        print(error)
                                    }
                                }
                                
                                let activity = PostActivity(actor: feedsClient.authUser.userId, object: isShowingComposeArea, tweetPhotoUrlString: tweetPhotoUrlString, tweetMovieAssetId: tweetMovieAssetId, tweetMoviePlaybackId: tweetMoviePlaybackId)
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
                            composeAreaIsFocussed = false
                            self.cameraViewModel.isCapturing.toggle()
                            print("tap to record video")
                        } label: {
                            Image(systemName: "video")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        .fullScreenCover(isPresented: $cameraViewModel.isCapturing, onDismiss: {
                            print("dismissed")
                        }, content: {
                            NavigationView {
                                CameraView(viewModel: cameraViewModel)
                                    .toolbar {
                                        ToolbarItem(placement: .navigationBarLeading) {
                                            Button {
                                                //TODO: Does this work? Dismiss sheet if already active
                                                presentationMode.wrappedValue.dismiss()
                                            } label: {
                                                Text("Cancel")
                                            }
                                        }
                                    }
                            }
                        })
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

// struct AddNewTweetView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNewTweetView()
//    }
// }
