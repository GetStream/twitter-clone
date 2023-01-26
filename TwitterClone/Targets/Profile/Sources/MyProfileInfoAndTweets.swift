//
//  ProfileInfoAndTweets.swift
//  TwitterClone
//

import SwiftUI
import TwitterCloneUI
import Timeline

struct MyProfileInfoAndTweets: View {
    @State private var selection = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    MyProfileImage()
                        .scaleEffect(1.2)
                    
                    Spacer()
                    
                    Button{
                        print("Navigate to edit profile page")
                    } label: {
                        Text("Edit profile")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                ProfileInfoView(myProfile: MyProfileData)
                
                Picker("For You and Following picker", selection: $selection) {
                    Text("Tweets").tag(0)
                    Text("Likes").tag(2)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                
                // MARK: Display the content under each picker
                if selection == 0 { // My own tweets
                    ForYouFeedsView()
                        .frame(height: UIScreen.main.bounds.height)
                } else { // Tweets I have liked
                    FollowingFeedsView(followingTweets: FollowingTweetData)
                        .frame(height: UIScreen.main.bounds.height)
                }
            }.padding()
        }
       
        
    }
}

struct MyProfileInfoAndTweets_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileInfoAndTweets()
            .preferredColorScheme(.dark)
    }
}
