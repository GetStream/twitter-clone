//
//  ProfileInfoAndTweets.swift
//  TwitterClone
//

import SwiftUI
import TwitterCloneUI
import TimelineUI
import Feeds

struct MyProfileInfoAndTweets: View {
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
                        print("Navigate to edit profile page")
                    } label: {
                        Text("Edit profile")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.borderedProminent)
                }

                ProfileInfoView(myProfile: myProfileData)

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
