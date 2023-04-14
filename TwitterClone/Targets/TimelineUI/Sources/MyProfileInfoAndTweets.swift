//
//  ProfileInfoAndTweets.swift
//  TwitterClone
//

import SwiftUI
import TwitterCloneUI
import Feeds
import Auth
import Profile

public struct MyProfileInfoAndTweets: View {
    @EnvironmentObject var profileInfoViewModel: ProfileInfoViewModel
    private var feedsClient: FeedsClient

    @State private var selection = 0

    public init(feedsClient: FeedsClient) {
        self.feedsClient = feedsClient
    }
    
    public var body: some View {
        MyProfile(footerContent: {
             ForYouFeedsView(feedType: .user(userId: feedsClient.authUser.userId))
                .frame(height: UIScreen.main.bounds.height)
        })
    }
}

struct MyProfileInfoAndTweets_Previews: PreviewProvider {
    static let feedsClient = FeedsClient.previewClient()
    static let feedUser = FeedUser.previewUser()

    static var previews: some View {
        MyProfileInfoAndTweets(feedsClient: feedsClient)
            .environmentObject(ProfileInfoViewModel(feedUser: feedUser))
            .preferredColorScheme(.dark)
    }
}
