//
//  ProfileInfoAndTweets.swift
//  TwitterClone
//

import SwiftUI
import TwitterCloneUI
import TimelineUI
import Feeds

struct MyProfileInfoAndTweets: View {
    private var feedsClient: FeedsClient
    
    @StateObject var profileInfoViewModel = ProfileInfoViewModel()

    @State private var selection = 0

    init(feedsClient: FeedsClient) {
        self.feedsClient = feedsClient
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    if let profilePicture = profileInfoViewModel.feedUser?.profilePicture {
                        ProfileImage(imageUrl: profilePicture, action: {})
                            .scaleEffect(1.2)
                    } else {
                        Image(systemName: "person.circle")
                            .scaleEffect(1.5)
                    }
                    Spacer()

                    Button {
                        print("Navigate to edit profile page")
                    } label: {
                        Text("Edit profile")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.borderedProminent)
                }

                ProfileInfoView(viewModel: profileInfoViewModel, myProfile: myProfileData)

                ForYouFeedsView(feedType: .user(userId: feedsClient.auth.authUser?.userId))
                    .frame(height: UIScreen.main.bounds.height)
            }.padding()
        }
        .task {
            profileInfoViewModel.feedUser = try? await feedsClient.user()
        }

    }
}

// struct MyProfileInfoAndTweets_Previews: PreviewProvider {
//    static var previews: some View {
//        MyProfileInfoAndTweets()
//            .preferredColorScheme(.dark)
//    }
// }
