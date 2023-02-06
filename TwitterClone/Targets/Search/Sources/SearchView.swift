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
        
    func runSearch() {
        Task {
            if let feedClient = self.feedClient {
                let users = try await feedClient.auth.users(matching: searchText)
                self.users.removeAll()
                self.users.append(contentsOf: users)
            }
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
                    Button("Follow") {
                        Task {
                            do {
                                try await feedClient.follow(target: user.userId, activityCopyLimit: 100)
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
