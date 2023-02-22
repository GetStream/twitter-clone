//
//  ContentView.swift
//  TTwin

import SwiftUI

import Feeds
import Combine
import Auth
import InstantSearchCore
import InstantSearchSwiftUI

@MainActor
class AlgoliaController: ObservableObject {
    let searcher: HitsSearcher
    let searchBoxInteractor: SearchBoxInteractor
    let searchBoxController: SearchBoxObservableController

    let hitsInteractor: HitsInteractor<FeedUser>
    let hitsController: HitsObservableController<FeedUser>
  
    var feedsClient: FeedsClient
    var auth: TwitterCloneAuth
    
    func submit() {
        searchBoxController.submit()
        Task {
            let feedFollowers: [FeedFollower]
            followedUserFeedIds.removeAll()
            feedFollowers = try await feedsClient.following()
            feedFollowers.forEach { followedUserFeedIds.insert($0.targetId) }
        }
    }
    
    @Published var followedUserFeedIds = Set<String>()
    
    init(feedsClient: FeedsClient, auth: TwitterCloneAuth) {
        self.feedsClient = feedsClient
        self.auth = auth
    self.searcher = HitsSearcher(appID: "BGP9QX4VDE",
                                 apiKey: "d50d7e16b4341c04814ef66977faa4c2",
                                 indexName: "TwitterCloneUsers")
    self.searchBoxInteractor = .init()
    self.searchBoxController = .init()
    self.hitsInteractor = .init()
    self.hitsController = .init()
    setupConnections()
  }
  
  func setupConnections() {
    searchBoxInteractor.connectSearcher(searcher)
    searchBoxInteractor.connectController(searchBoxController)
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsController)
  }
    
    func isFollowing(user: FeedUser) -> Bool {
        return followedUserFeedIds.contains("user:" + user.userId)
    }
    func unfollow(user: FeedUser) {
        Task {
            do {
                try await feedsClient.unfollow(target: user.userId, keepHistory: true)
                followedUserFeedIds.remove("user:" + user.userId)
            } catch {
                print(error)
            }
        }
    }
    
    func follow(user: FeedUser) {
        Task {
            do {
                try await feedsClient.follow(target: user.userId, activityCopyLimit: 100)
                followedUserFeedIds.insert("user:" + user.userId)
            } catch {
                print(error)
            }
        }
    }
      
}

public struct NewSearchView: View {
    
    @StateObject var algoliaController: AlgoliaController
    
    @ObservedObject var searchBoxController: SearchBoxObservableController
    @ObservedObject var hitsController: HitsObservableController<FeedUser>

    @State private var isEditing = false
    
    public init(feedsClient: FeedsClient, auth: TwitterCloneAuth) {
        let algoliaController = AlgoliaController(feedsClient: feedsClient, auth: auth)
        _algoliaController = StateObject(wrappedValue: algoliaController)
        _searchBoxController = ObservedObject(wrappedValue: algoliaController.searchBoxController)
        _hitsController = ObservedObject(wrappedValue: algoliaController.hitsController)
    }

    public var body: some View {
        VStack(spacing: 7) {
            SearchBar(text: $searchBoxController.query,
                      isEditing: $isEditing,
                      onSubmit: algoliaController.submit)
            HitsList(hitsController) { user, _ in
                if let user {
                    HStack {
                        Text(user.username)
                            .font(.headline)
                        Text(user.userId)
                        Spacer()
                        if user.userId != algoliaController.auth.authUser?.userId {
                            if algoliaController.isFollowing(user: user) {
                                Button("Unfollow") {
                                    algoliaController.unfollow(user: user)
                                }
                                .buttonStyle(.borderedProminent)
                                
                            } else {
                                Button("Follow") {
                                    algoliaController.follow(user: user)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }

            } noResults: {
                Text("No Results")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationBarTitle("Algolia & SwiftUI")
    }
}

@MainActor
class UserSearchViewModel: ObservableObject {
    var feedsClient: FeedsClient
    var auth: TwitterCloneAuth
    
    @Published var users = [UserReference]()
    @Published var searchText: String = ""
    @Published var followedUserFeedIds = Set<String>()
    
    init(feedsClient: FeedsClient, auth: TwitterCloneAuth) {
        self.feedsClient = feedsClient
        self.auth = auth
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
    
    public init(feedsClient: FeedsClient, auth: TwitterCloneAuth) {
       _viewModel = StateObject(wrappedValue: UserSearchViewModel(feedsClient: feedsClient, auth: auth))
    }

    public var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                HStack {
                    Text(user.username)
                        .font(.headline)
                    Text(user.userId)
                    Spacer()
                    if viewModel.isFollowing(user: user) {
                        Button("Unfollow") {
                            viewModel.unfollow(user: user)
                        }
                        .buttonStyle(.borderedProminent)

                    } else {
                        Button("Follow") {
                            viewModel.follow(user: user)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .listStyle(.plain)
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
