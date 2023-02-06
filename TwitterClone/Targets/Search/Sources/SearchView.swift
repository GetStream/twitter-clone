//
//  ContentView.swift
//  TTwin

//
// From SwiftUI by Example by Paul Hudson
// https://www.hackingwithswift.com/quick-start/swiftui
//
// You're welcome to use this code for any purpose,
// commercial or otherwise, with or without attribution.
//

import SwiftUI

import Feeds
import Combine
import Auth

@MainActor
class UserSearchViewModel: ObservableObject {
    var feedClient: FeedsClient?
    @Published var users = [UserReference]()
    @Published var searchText: String = ""
    @Published var followedUserFeedIds = Set<String>()
        
    func runSearch() {
        Task {
            let users: [UserReference]
            let feedFollowers: [FeedFollower]
            if let feedClient {
                users = try await feedClient.auth.users(matching: searchText)
                feedFollowers = try await feedClient.following(feedId: "")
            } else {
                users = []
                feedFollowers = []
            }
                                                         
            self.users.removeAll()
            self.users.append(contentsOf: users)
            followedUserFeedIds.removeAll()
            feedFollowers.forEach { followedUserFeedIds.insert($0.targetId) }
        }
    }
}

public struct SearchView: View {
    @EnvironmentObject var feedClient: FeedsClient
    @StateObject var viewModel = UserSearchViewModel()

    public init() {}

    public var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                VStack(alignment: .leading) {
                    Text(user.username)
                        .font(.headline)
                    
                    Text(user.userId)
                    let following = viewModel.followedUserFeedIds.contains { $0 == "user:" + user.userId }
                    Button(following ? "Unfollow" : "Follow") {
                        Task {
                            do {
                                if following {
                                    try await feedClient.unfollow(target: user.userId, keepHistory: true)
                                    viewModel.followedUserFeedIds.remove("user:" + user.userId)
                                } else {
                                    try await feedClient.follow(target: user.userId, activityCopyLimit: 100)
                                    viewModel.followedUserFeedIds.insert("user:" + user.userId)
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Search Users")
            .searchable(text: $viewModel.searchText)
            .autocapitalization(.none)
            .task {
                viewModel.feedClient = feedClient
                viewModel.runSearch()
            }
            .onSubmit(of: .search) {
                viewModel.runSearch()
            }
        }
    }
}

// struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
// }
