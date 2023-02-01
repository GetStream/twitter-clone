//
//  HomeView.swift
//  TTwin
//

import SwiftUI
import TwitterCloneUI
import Auth
import Feeds
import Search

public struct HomeTimelineView: View {
    @EnvironmentObject var auth: TwitterCloneAuth
    @EnvironmentObject var feedsClient: FeedsClient
    @State private var isAddingTweet = false

    public init() {}

    public var body: some View {
        NavigationStack {
                VStack {
                    NewlyTweetedButton()
                    TabView {
                        ZStack {
                            FeedsView()
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    
                                    Button {
                                        self.isAddingTweet.toggle()
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 42))
                                            .padding(.all)
                                    }
                                    .sheet(isPresented: $isAddingTweet, content: {
                                        AddNewTweetView()
                                            .environmentObject(feedsClient)
                                    })
                                }
                            }
                        }.tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                        SearchView()
                            .tabItem {
                                Image(systemName: "magnifyingglass")
                                Text("Search")
                            }
                        
                        Text("")
                            .tabItem {
                                Image(systemName: "waveform.and.mic")
                                Text("Spaces")
                            }
                        
                        Text("")
                            .tabItem {
                                Image(systemName: "bell")
                                Text("Notifications")
                            }
                            .badge(10)
                        
                        Text("")
                            .tabItem {
                                Image(systemName: "text.bubble")
                                Text("Chats")
                            }
                    }
                    //                TabBarView()
                    //                    .frame(width: .infinity, height: 68)
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

// struct HomeTimelineView_Previews: PreviewProvider {
//    static let auth = TwitterCloneAuth()
//    static var feedClient = FeedsClient.previewClient()
//    static var previews: some View {
//        HomeTimelineView()
//            .environmentObject(auth)
//            .environmentObject(feedClient)
//            .preferredColorScheme(.dark)
//    }
// }
