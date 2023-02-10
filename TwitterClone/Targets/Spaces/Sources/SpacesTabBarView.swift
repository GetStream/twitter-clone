//
// SpacesTabBarView.swift
//  TTwin
//

import SwiftUI
import Search
import Feeds
import HomeUI

public struct SpacesTabBarView: View {
    @State private var selectedTab = 1
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            Text("")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
            
            Text("")
                .tabItem {
                    Image(systemName: "waveform.and.mic")
                    Text("Spaces")
                }
                .tag(2)
            
            Text("")
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Notifications")
                }
                .badge(10)
                .tag(2)
            
            Text("")
                .tabItem {
                    Image(systemName: "text.bubble.fill")
                    Text("Chats")
                }
                .tag(2)
        }
        .accentColor(.streamBlue)
        .onAppear {
            selectedTab = 2
        }
    }
}

struct SpacesTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        SpacesTabBarView()
            .preferredColorScheme(.dark)
    }
}
