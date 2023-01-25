//
//  HomeView.swift
//  TTwin
//

import SwiftUI
import TwitterCloneAuth
import TwitterCloneFeeds

struct HomeTimelineView: View {
    @EnvironmentObject var auth: TwitterCloneAuth
    @EnvironmentObject var feedsClient: FeedsClient
    
    var body: some View {
        NavigationStack {
            VStack {
                NewlyTweetedButton()
        
                FeedsView()
                
                HStack {
                    Spacer()
                    
                    Button {
                        print("Tap this button to initiate a new message with Stream Chat")
                    } label: {
                        Image(systemName: "plus.message.fill")
                            .font(.system(size: 42))
                            .padding(.horizontal)
                    }
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

struct HomeTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTimelineView()
            .preferredColorScheme(.dark)
    }
}
