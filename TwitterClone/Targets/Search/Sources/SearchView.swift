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

struct Tweet: Identifiable, Codable {
    let id: Int
    var user: String
    var text: String
}

enum SearchScope: String, CaseIterable {
    case recent, all
}

public struct SearchView: View {
    @State private var tweets = [Tweet]()

    @State private var searchText = ""
    @State private var searchScope = SearchScope.recent

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                ForEach(filteredTweets) { message in
                    VStack(alignment: .leading) {
                        Text(message.user)
                            .font(.headline)

                        Text(message.text)
                    }
                }
            }
            .navigationTitle("Search Tweets")
        }
        .searchable(text: $searchText)
        .searchScopes($searchScope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
            }
        }
        .onAppear(perform: runSearch)
        .onSubmit(of: .search, runSearch)
        .onChange(of: searchScope) { _ in runSearch() }
    }

    var filteredTweets: [Tweet] {
        if searchText.isEmpty {
            return tweets
        } else {
            return tweets.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func runSearch() {
        Task {
            guard let url = URL(string: "https://hws.dev/\(searchScope.rawValue).json") else { return }

            let (data, _) = try await URLSession.shared.data(from: url)
            tweets = try JSONDecoder().decode([Tweet].self, from: data)
        }
    }
}

// struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
// }
