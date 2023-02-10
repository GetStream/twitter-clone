//
//  TabBarView.swift
//  TTwin
//

import SwiftUI

import Search
import Auth

import Feeds

public struct TabBarView: View {
    @EnvironmentObject var feedsClient: FeedsClient
    @EnvironmentObject var auth: TwitterCloneAuth
    
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
            }

            SearchView(feedsClient: feedsClient, auth: auth)
                .tabItem {
                    Button {
                        self.isSearchShowing.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }

            Text("")
                .tabItem {
                    Image(systemName: "waveform.and.mic")
                }

            Text("")
                .tabItem {
                    Image(systemName: "bell")
                }
                .badge(10)

            Text("")
                .tabItem {
                    Image(systemName: "text.bubble")
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
