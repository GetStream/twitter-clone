//
//  FollowingFeedsView.swift
//  TTwin

import SwiftUI

struct FollowingFeedsView: View {
    
    var followingTweets: [FollowingTweetsStructure] = []
    
    var body: some View {
        List(followingTweets) {
            item in
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: "\(item.userProfilePhoto)")) { loading in
                    if let image = loading.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                    } else if loading.error != nil {
                        Text("There was an error loading the profile image.")
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 48, height: 48)
                .accessibilityLabel("Profile photo")
                .accessibilityAddTraits(.isButton)
                
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("\(item.userName)")
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .layoutPriority(1)
                        
                        Text("\(item.userHandle)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .layoutPriority(1)
                        
                        Text("* \(item.tweetSentAt)")
                            .font(.subheadline)
                            .lineLimit(1)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Image(systemName:
                                "\(item.actionsMenuIcon)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    
                    HStack(alignment: .bottom) {
                        Text("\(item.tweetSummary)")
                            .layoutPriority(2)
                        Text("\(item.hashTag)")
                            .foregroundColor(.streamGreen)
                            .layoutPriority(3)
                        
                    }.font(.subheadline)
                    
                    HStack{
                        Image(systemName: "\(item.commentIcon)")
                        Text("\(item.numberOfComments)")
                        Spacer()
                        Image(systemName: "\(item.retweetIcon)")
                        Spacer()
                        Image(systemName: "\(item.likeIcon)")
                        Text("\(item.numberOfLikes)")
                        Spacer()
                        Image(systemName: "\(item.shareTweetIcon)")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
            }
        } //LIST STYLES
        .listStyle(.plain)
    }
}

struct FollowingFeedsView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingFeedsView(followingTweets: FollowingTweetData)
            .preferredColorScheme(.dark)
    }
}
