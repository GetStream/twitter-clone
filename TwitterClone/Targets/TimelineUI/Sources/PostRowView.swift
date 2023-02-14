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

class PostRowViewViewModel: ObservableObject {
    var item: EnrichedPostActivity
    
    @Published
    var liked: Bool
    
    init(item: EnrichedPostActivity) {
        liked = false
        self.item = item
    }
}

struct PostRowView: View {

    var model: PostRowViewViewModel
    
    @State private var isShowingActivityProfile = false

    var body: some View {
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

                    Image(systemName: "ellipsis.circle")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .buttonStyle(.borderless)
                        .contextMenu {
                            Button(role: .destructive) {
                                // TODO implement activity deletion
                                print("Delete")
                            } label: {
                                Label("Delete activity", systemImage: "trash")
                            }
                        }
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
                    .frame(width: .infinity, height: 180)
                    .cornerRadius(16)
                    .accessibilityLabel("Tweet with photo")
                    .accessibilityAddTraits(.isButton)
                }

                HStack {
                    Image(systemName: "message")
                    Text("\(model.item.numberOfComments ?? "x")")
                    Spacer()
                    Image(systemName: "arrow.2.squarepath")
                    Spacer()
                    Button {
                        model.liked.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "heart")
                            Text("\(model.item.numberOfLikes ?? "0")")
                        }
                    }
                    Spacer()
                    Image(systemName: "square.and.arrow.up.on.square")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
    }
}

// struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        return PostRowView(item: EnrichedPostActivity.previewPostActivities()[0])
//            .preferredColorScheme(.dark)
//    }
// }
