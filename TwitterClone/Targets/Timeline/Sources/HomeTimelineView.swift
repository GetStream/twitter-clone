//
//  HomeView.swift
//  TTwin
//

import SwiftUI
import TwitterCloneUI
import Auth
import Feeds

public struct HomeTimelineView: View {
    @EnvironmentObject var auth: TwitterCloneAuth
    @EnvironmentObject var feedsClient: FeedsClient
    @State private var isAddingTweet = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack {
                NewlyTweetedButton()
        
                FeedsView()
                
                HStack {
                    Spacer()
                    
                    Button {
                        self.isAddingTweet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 42))
                            .padding(.horizontal)
                    }
                    .sheet(isPresented: $isAddingTweet, content: {
                        AddNewTweetView()
                            .environmentObject(feedsClient)
                    })
                }
                
                TabBarView()
                    .frame(width: .infinity, height: 68)
            } // Header, scrollable feeds, tab bar
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    MyProfileImage()
                }
                
                ToolbarItem(placement: .principal) {
                    Button {
                        print("TTwin logo pressed")
                    } label: {
                        TTwinLogo()
                    }
                }
            }
        }
    }
}

//struct HomeTimelineView_Previews: PreviewProvider {
//    static let auth = TwitterCloneAuth()
//    static var feedClient = FeedsClient.previewClient()
//    static var previews: some View {
//        HomeTimelineView()
//            .environmentObject(auth)
//            .environmentObject(feedClient)
//            .preferredColorScheme(.dark)
//    }
//}
