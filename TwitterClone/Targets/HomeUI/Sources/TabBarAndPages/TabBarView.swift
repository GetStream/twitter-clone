//
//  TabBarView.swift
//  TTwin
//

import SwiftUI

import Search

import Feeds

public struct TabBarView: View {
    @EnvironmentObject var feedsClient: FeedsClient
    @State private var selectedFeeds = 1
    @State private var isSearchShowing = false

    public init() {}

    public var body: some View {
        TabView(selection: $selectedFeeds) {
            ZStack {
                Rectangle()
                    .foregroundStyle(.streamBlue) // From the color extension
                    .opacity(0.1)
                    .ignoresSafeArea()
               Text("Home view")
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }

            SearchView(feedsClient: feedsClient)
                .tabItem {
                    Button {
                        self.isSearchShowing.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
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
    }
}

// struct TabBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBarView()
//            .preferredColorScheme(.dark)
//    }
// }
