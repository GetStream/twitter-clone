//
//  ProfileInfoAndTweets.swift
//  TwitterClone
//

import SwiftUI
import TwitterCloneUI
import Feeds
import Profile

public struct MyProfileInfoAndTweets: View {
    private var feedsClient: FeedsClient
    
    @State private var isShowingEditProfile = false
    
    @EnvironmentObject var profileInfoViewModel: ProfileInfoViewModel

    @State private var selection = 0

    public init(feedsClient: FeedsClient) {
        self.feedsClient = feedsClient
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    ProfileImage(imageUrl: profileInfoViewModel.feedUser?.profilePicture, action: {})
                            .scaleEffect(1.2)

                    Spacer()

                    Button {
                        isShowingEditProfile.toggle()
                        print("Navigate to edit profile page")
                    } label: {
                        Text("Edit profile")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .sheet(isPresented: $isShowingEditProfile, content: {
                        if let feedUser = profileInfoViewModel.feedUser {
                            EditProfileView(feedsClient: feedsClient, currentUser: feedUser)
                        }
                    })
                    .buttonStyle(.borderedProminent)
                }

                ProfileInfoView(viewModel: profileInfoViewModel)

                ForYouFeedsView(feedType: .user(userId: feedsClient.auth.authUser?.userId))
                    .frame(height: UIScreen.main.bounds.height)
            }.padding()
        }
    }
}

// struct MyProfileInfoAndTweets_Previews: PreviewProvider {
//    static var previews: some View {
//        MyProfileInfoAndTweets()
//            .preferredColorScheme(.dark)
//    }
// }
