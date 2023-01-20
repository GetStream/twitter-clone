//
//  TabBarView.swift
//  TTwin
//

import SwiftUI

struct TabBarView: View {
    
    @State private var selectedFeeds = 0
    
    var body: some View {
        TabView {
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
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            AudioSpacesView()
                .tabItem {
                    Image(systemName: "waveform.and.mic")
                    Text("Spaces")
                }
            
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
                .badge(10)
            
            ChatsView()
                .tabItem {
                    Image(systemName: "text.bubble")
                    Text("Chats")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .preferredColorScheme(.dark)
    }
}

