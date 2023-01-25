//
//  ProfileInfoAndTweets.swift
//  TwitterClone
//

import SwiftUI

struct UnfollowerProfileInfoAndTweets: View {
    @State private var selection = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    UnfollowerProfileImage()
                        .scaleEffect(1.2)
                    
                    Spacer()
                    
                    HStack {
                        Button{
                            print("receives notifications from this user")
                        } label: {
                            Image(systemName: "bell.badge.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .font(.title)
                        }
                        
                        Button{
                            print("")
                        } label: {
                            Image(systemName: "message.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .font(.title)
                        }
                        
                        Button{
                            print("")
                        } label: {
                            Text("Follow")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                ProfileInfoView(myProfile: UnfollowerProfileData)
                
                Picker("For You and Following picker", selection: $selection) {
                    Text("Tweets").tag(0)
                    Text("Likes").tag(2)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                
                // MARK: Display the content under each picker
                if selection == 0 { // My own tweets
                    ForYouFeedsView(forYouTweets: ForYouTweetData)
                        .frame(height: UIScreen.main.bounds.height)
                } else { // Tweets I have liked
                    FollowingFeedsView(followingTweets: FollowingTweetData)
                        .frame(height: UIScreen.main.bounds.height)
                }
            }.padding()
        }
        
        
    }
}

struct UnfollowerProfileInfoAndTweets_Previews: PreviewProvider {
    static var previews: some View {
        UnfollowerProfileInfoAndTweets()
            .preferredColorScheme(.dark)
    }
}
