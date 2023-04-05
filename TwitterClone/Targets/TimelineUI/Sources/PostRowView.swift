//
//  File.swift
//  Timeline
//
//  Created by Jeroen Leenarts on 28/01/2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Feeds

import SwiftUI
import TwitterCloneUI
import Profile
import Auth

import AVKit

@MainActor
class PostRowViewViewModel: ObservableObject {
    var auth: TwitterCloneAuth
    var item: EnrichedPostActivity
    var profileInfoViewModel: ProfileInfoViewModel
    
    @Published
    var liked: Bool
    
    @Published
    var assetPlaybackUrlString: String?
    
    init(item: EnrichedPostActivity, profileInfoViewModel: ProfileInfoViewModel, auth: TwitterCloneAuth) {
        liked = false
        self.item = item
        self.profileInfoViewModel = profileInfoViewModel
        self.auth = auth
    }
    
    func loadMuxAsset() async {
        if let playbackId = item.tweetMoviePlaybackId {
            assetPlaybackUrlString = "https://stream.mux.com/\(playbackId)"
        }
    }
}

struct PostRowView: View {

    @StateObject
    var model: PostRowViewViewModel
    @EnvironmentObject var feedClient: FeedsClient
    
    @State private var isShowingActivityProfile = false
    @State private var isShowingReplySheet = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationLink {
            Text("detail")
        } label: {
            HStack(alignment: .top) {
                ProfileImage(imageUrl: model.item.actor.profilePicture, action: {
                    self.isShowingActivityProfile.toggle()
                })
                .accessibilityLabel("Profile of \(model.item.actor.fullname)")
                .accessibilityAddTraits(.isButton)
                .sheet(isPresented: $isShowingActivityProfile, content: {
                    ProfileFollower(contentView: {
                        AnyView(ProfileInfoAndTweets(userId: model.item.actor.userId, profilePicture: model.item.actor.profilePicture))
                    })
                })
                
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(model.item.actor.fullname)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .layoutPriority(1)
                        
                        Text(model.item.actor.username)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .layoutPriority(1)
                        
                        Text("* " + model.item.postAge)
                            .font(.subheadline)
                            .lineLimit(1)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        //                    Image(systemName: "ellipsis.circle")
                        //                        .font(.subheadline)
                        //                        .foregroundColor(.secondary)
                        //                        .buttonStyle(.borderless)
                        //                        .contextMenu {
                        //                            Button(role: .destructive) {
                        //                                // TODO: implement activity deletion
                        //                                print("Delete")
                        //                            } label: {
                        //                                Label("Delete activity", systemImage: "trash")
                        //                            }
                        //                        }
                    }
                    
                    HStack(alignment: .bottom) {
                        Text(model.item.object)
                            .layoutPriority(2)
                    }.font(.subheadline)
                    
                    if let tweetPhoto = model.item.tweetPhoto {
                        AsyncImage(url: URL(string: tweetPhoto)) { loading in
                            if let image = loading.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                            } else if loading.error != nil {
                                Image(systemName: "exclamationmark.icloud")
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: nil, height: 180)
                        .cornerRadius(16)
                        .accessibilityLabel("Tweet with photo")
                        .accessibilityAddTraits(.isButton)
                    }
                    
                    if let assetPlaybackUrlString = model.assetPlaybackUrlString, let assetPlaybackUrl = URL(string: assetPlaybackUrlString) {
                        VideoPlayer(player: AVPlayer(url: assetPlaybackUrl))
                            .frame(width: nil, height: 180)
                            .cornerRadius(16)
                    }
                    
                    HStack {
                        Button {
                            // Add retweet action
                            isShowingReplySheet.toggle()
                        } label: {
                            Label("\(model.item.reactionCounts.replyCount)", systemImage: "message")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.borderless)
                        .sheet(isPresented: $isShowingReplySheet) {
                            VStack(spacing: 32) {
                                ReplyTweetView(profileInfoViewModel: model.profileInfoViewModel, parentActivityId: model.item.id)
                                    .padding(.horizontal, 32)
                            }
                            // Add the presentation detents to the content inside the sheet
                            //.presentationDetents([.height(200)])
                            .presentationDetents([.fraction(0.25)])
                        }
                        
                        //                    Spacer()
                        RetweetView()
                        Spacer()
                        Button {
                            model.liked.toggle()
                            Task {
                                // TODO detect own like and remove own like
                                
                                try await feedClient.addReaction(model.item.id, reactionType: .like, reply: "")
                            }
                        } label: {
                            HStack {
                                // TODO detect own like and make red filled heart.
                                Image(systemName: "heart")
                                Text("\(model.item.reactionCounts.likeCount)")
                            }
                        }
                        .buttonStyle(.borderless)
                        
                        Spacer()
                        //TODO: share tweet                    Image(systemName: "square.and.arrow.up.on.square")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
            }
        }
        .task {
            await model.loadMuxAsset()
        }
    }
}

// struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        return PostRowView(item: EnrichedPostActivity.previewPostActivities()[0])
//            .preferredColorScheme(.dark)
//    }
// }
