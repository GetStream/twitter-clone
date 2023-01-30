//
//  AddNewTweetView.swift
//  Timeline
//
//  Created by amos.gyamfi@getstream.io on 26.1.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI
import Auth

import Feeds

struct AddNewTweetView: View {
    @EnvironmentObject var feedsClient: FeedsClient
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isShowingComposeArea = ""
    @State private var isCanceled = false
    @State private var isRecording = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    MyProfileImage()
                    TextField("What's happening?", text: $isShowingComposeArea, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(10)
                        .font(.caption)
                        .padding()
                        .keyboardType(.twitter)
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            self.isCanceled.toggle()
                        }
                        .fullScreenCover(isPresented: $isCanceled, content: HomeTimelineView.init)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        AsyncButton("Tweet") {
                            do {
                                guard let userId = feedsClient.auth.authUser?.userId else {
                                    throw AuthError.noLoadedAuthUser
                                }
                                let activity = PostActivity(actor: userId, object: isShowingComposeArea)
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
                    
                    // Pin to the device keyboard
                    ToolbarItem(placement: .keyboard) {
                        Button {
                            print("tap to upload an image")
                        } label: {
                           Image(systemName: "photo.on.rectangle.angled")
                                .font(.subheadline)
                                .fontWeight(.bold)
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
                        .fullScreenCover(isPresented: $isRecording, content: RecordAudioView.init)
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
                
                Spacer()
            }
        }
    }
}

//struct AddNewTweetView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNewTweetView()
//    }
//}
