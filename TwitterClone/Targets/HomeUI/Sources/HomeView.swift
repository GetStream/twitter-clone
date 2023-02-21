//
//  HomeView.swift
//  TTwin
//

import SwiftUI
import TwitterCloneUI
import Auth
import Feeds
import Search
import Profile
import TimelineUI
import DirectMessages
import Spaces
import Chat
import StreamChat

public struct HomeView: View {
    @StateObject
    var feedsClient: FeedsClient
    
    @StateObject
    var chatModel = ChatModel()
    
    @EnvironmentObject
    var auth: TwitterCloneAuth
    
    @StateObject
    var profileInfoViewModel = ProfileInfoViewModel()
    
    @State
    private var isAddingTweet = false
    
    @State private var isShowingProfile = false
    
    public init(authUser: AuthUser) {
        _feedsClient = StateObject(wrappedValue: FeedsClient.productionClient(authUser: authUser))
    }
    
    public var body: some View {
        NavigationStack {
            VStack {
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
                                    Image("newTweetButton")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 46, height: 46)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 16))
                                }
                                .sheet(isPresented: $isAddingTweet, content: {
                                    AddNewTweetView()
                                        .environmentObject(feedsClient)
                                })
                            }
                        }
                    }.tabItem {
                        Image(systemName: "house")
                    }
                    SearchView(feedsClient: feedsClient, auth: auth)
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                        }
                    
                    SpacesTimelineView()
                        .tabItem {
                            Image("spacesTabBarIcon")
                        }
                    
                    Text("")
                        .tabItem {
                            Image(systemName: "bell")
                        }
                        .badge(10)
                    
                    DirectMessagesView()
                        .tabItem {
                            Image(systemName: "text.bubble")
                        }
                }
                //                TabBarView()
                //                    .frame(width: .infinity, height: 68)
            } // Header, scrollable feeds, tab bar
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ProfileImage(imageUrl: profileInfoViewModel.feedUser?.profilePicture, action: {
                        self.isShowingProfile.toggle()
                    })
                    .sheet(isPresented: $isShowingProfile, content: {
                        MyProfile(contentView: { AnyView(MyProfileInfoAndTweets(feedsClient: feedsClient))
                        })
                        .environmentObject(feedsClient)
                    })
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
        .environmentObject(feedsClient)
        .environmentObject(profileInfoViewModel)
        .environmentObject(chatModel)
        .task {
            do {
                let feedUser = try await feedsClient.user()
                profileInfoViewModel.feedUser = feedUser
                try chatModel.connectUser(authUser: feedsClient.authUser, feedUser: feedUser)
                try await feedsClient.follow(target: feedsClient.authUser.userId, activityCopyLimit: 10)
            } catch {
                // TODO better error handling
                print(error)
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
