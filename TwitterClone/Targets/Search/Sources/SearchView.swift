//
//  ContentView.swift
//  TTwin

import SwiftUI

import Feeds
import Combine
import Auth

@MainActor
class UserSearchViewModel: ObservableObject {
    var feedsClient: FeedsClient
    @EnvironmentObject var auth: TwitterCloneAuth
    @Published var users = [UserReference]()
    @Published var searchText: String = ""
    @Published var followedUserFeedIds = Set<String>()
    
    init(feedsClient: FeedsClient) {
        self.feedsClient = feedsClient
    }
    
    func isFollowing(user: UserReference) -> Bool {
        return followedUserFeedIds.contains("user:" + user.userId)
    }
    func unfollow(user: UserReference) {
        Task {
            do {
                try await feedsClient.unfollow(target: user.userId, keepHistory: true)
                followedUserFeedIds.remove("user:" + user.userId)
            } catch {
                print(error)
            }
        }
    }
    
    func follow(user: UserReference) {
        Task {
            do {
                try await feedsClient.follow(target: user.userId, activityCopyLimit: 100)
                followedUserFeedIds.insert("user:" + user.userId)
            } catch {
                print(error)
            }
        }
    }
        
    func runSearch() {
        Task {
            let users: [UserReference]
            let feedFollowers: [FeedFollower]
            self.users.removeAll()
            followedUserFeedIds.removeAll()

            users = try await auth.users(matching: searchText)
            feedFollowers = try await feedsClient.following()
                                                         
            self.users.append(contentsOf: users)
            feedFollowers.forEach { followedUserFeedIds.insert($0.targetId) }
        }
    }
}

public struct SearchView: View {
    @StateObject var viewModel: UserSearchViewModel

    public init(feedsClient: FeedsClient) {        
       _viewModel = StateObject(wrappedValue: UserSearchViewModel(feedsClient: feedsClient))
    }

    public var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                VStack(alignment: .leading) {
                    Text(user.username)
                        .font(.headline)
                    
                    Text(user.userId)
                    if viewModel.isFollowing(user: user) {
                        Button("Unfollow") {
                            viewModel.unfollow(user: user)
                        }
                        .buttonStyle(.borderedProminent)

                    } else {
                        Button("Follow") {
                            viewModel.follow(user: user)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Search Users")
            .searchable(text: $viewModel.searchText)
            .autocapitalization(.none)
            .task {
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
