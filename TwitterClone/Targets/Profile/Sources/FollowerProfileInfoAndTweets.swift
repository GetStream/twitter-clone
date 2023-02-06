//
//  ProfileInfoAndTweets.swift
//  TwitterClone
//

import SwiftUI

import TwitterCloneUI
import TimelineUI
import Feeds

struct FollowerProfileInfoAndTweets: View {
    @EnvironmentObject var feedsClient: FeedsClient
    @State private var selection = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    ProfileImage(imageUrl: "https://picsum.photos/id/64/200", action: {})
                        .scaleEffect(1.2)

                    Spacer()

                    Button {
                        print("receives notifications from this user")
                    } label: {
                        Image(systemName: "bell.badge.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title)
                    }

                    Button {
                        print("")
                    } label: {
                        Image(systemName: "message.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title)
                    }

                    Button {
                        print("")
                    } label: {
                        Text("Following")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.bordered)
                }

                ProfileInfoView(feedsClient: feedsClient, myProfile: followerProfileData)

                ForYouFeedsView()
                    .frame(height: UIScreen.main.bounds.height)
            }.padding()
        }

    }
}

// struct FollowerProfileInfoAndTweets_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowerProfileInfoAndTweets()
//            .preferredColorScheme(.dark)
//    }
// }
