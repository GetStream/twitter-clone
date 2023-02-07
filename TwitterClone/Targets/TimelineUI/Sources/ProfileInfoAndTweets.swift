//
//  ProfileInfoAndTweets.swift
//  TwitterClone
//

import SwiftUI

import TwitterCloneUI
import Feeds
import Profile

struct ProfileInfoAndTweets: View {
    var userId: String
    var profilePicture: String?
    
    @EnvironmentObject var feedsClient: FeedsClient
    @State private var selection = 0
    
    @StateObject var profileInfoViewModel = ProfileInfoViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    ProfileImage(imageUrl: profilePicture, action: {})
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

                ProfileInfoView(viewModel: profileInfoViewModel)

                ForYouFeedsView(feedType: .user(userId: userId))
                    .frame(height: UIScreen.main.bounds.height)
            }.padding()
        }
        .task {
            profileInfoViewModel.feedUser = try? await feedsClient.user(id: userId)
        }
    }
}

// struct FollowerProfileInfoAndTweets_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowerProfileInfoAndTweets()
//            .preferredColorScheme(.dark)
//    }
// }
