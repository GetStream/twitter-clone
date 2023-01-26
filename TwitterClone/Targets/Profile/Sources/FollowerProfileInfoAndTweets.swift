//
//  ProfileInfoAndTweets.swift
//  TwitterClone
//

import SwiftUI

import Timeline
import TwitterCloneUI

struct FollowerProfileInfoAndTweets: View {
    @State private var selection = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    FollowerProfileImage()
                        .scaleEffect(1.2)
                    
                    Spacer()
                    
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
                        Text("Following")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.bordered)
                }
                
                ProfileInfoView(myProfile: FollowerProfileData)
                
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

struct FollowerProfileInfoAndTweets_Previews: PreviewProvider {
    static var previews: some View {
        FollowerProfileInfoAndTweets()
            .preferredColorScheme(.dark)
    }
}
