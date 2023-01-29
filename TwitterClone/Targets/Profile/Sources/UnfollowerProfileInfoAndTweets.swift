//
//  ProfileInfoAndTweets.swift
//  TwitterClone
//

import SwiftUI
import TwitterCloneUI
import Timeline

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
                
                ForYouFeedsView()
                    .frame(height: UIScreen.main.bounds.height)
            }.padding()
        }
        
        
    }
}

//struct UnfollowerProfileInfoAndTweets_Previews: PreviewProvider {
//    static var previews: some View {
//        UnfollowerProfileInfoAndTweets()
//            .preferredColorScheme(.dark)
//    }
//}
