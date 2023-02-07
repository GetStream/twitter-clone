//
//  ProfileInfoAndTweets.swift
//  TwitterClone
//

import SwiftUI
import TwitterCloneUI

import TimelineUI
import Feeds

struct UnfollowerProfileInfoAndTweets: View {
    var feedsClient: FeedsClient
    
    @StateObject var profileInfoViewModel = ProfileInfoViewModel()

    @State private var selection = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    ProfileImage(imageUrl: "https://picsum.photos/id/64/200", action: {})
                        .scaleEffect(1.2)

                    Spacer()

                    HStack {
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
                            Text("Follow")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                ProfileInfoView(viewModel: profileInfoViewModel, myProfile: unfollowerProfileData)

                ForYouFeedsView()
                    .frame(height: UIScreen.main.bounds.height)
            }.padding()
        }
        .task {
            profileInfoViewModel.feedUser = try? await feedsClient.user()
        }
    }
}

// struct UnfollowerProfileInfoAndTweets_Previews: PreviewProvider {
//    static var previews: some View {
//        UnfollowerProfileInfoAndTweets()
//            .preferredColorScheme(.dark)
//    }
// }
