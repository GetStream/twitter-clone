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
                }
            }
            .navigationTitle("Search Users")
            .searchable(text: $viewModel.searchText)
            .task {
                viewModel.feedClient = feedClient
                viewModel.runSearch()
            }
            .onSubmit(of: .search) {
                viewModel.runSearch()
            }
            
            //            .searchScopes($searchScope) {
            //                ForEach(SearchScope.allCases, id: \.self) { scope in
            //                    Text(scope.rawValue.capitalized)
            //                }
            //            }
        }
//        .onChange(of: searchScope) { _ in runSearch() }
    }
}

// struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
// }
