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
                    
                    Button {
                        print("Navigate to edit profile page")
                    } label: {
                        Text("Edit profile")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                ProfileInfoView(myProfile: MyProfileData)
                
                ForYouFeedsView()
                    .frame(height: UIScreen.main.bounds.height)
            }.padding()
        }
       
        
    }
}

//struct MyProfileInfoAndTweets_Previews: PreviewProvider {
//    static var previews: some View {
//        MyProfileInfoAndTweets()
//            .preferredColorScheme(.dark)
//    }
//}
