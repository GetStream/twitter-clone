//
//  MyProfile.swift
//  TwitterClone
//

import SwiftUI

import TimelineUI
import Search
import Feeds

public struct ProfileUnfollower: View { @State private var selection = 0
    @State private var isShowingSearch = false
    @EnvironmentObject var feedsClient: FeedsClient

    public var body: some View {
        NavigationStack {
            VStack {
                UnfollowerProfileInfoAndTweets(feedsClient: feedsClient)
//                TabBarView()
//                    .frame(height: 68)
            } // All views
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("")
            .toolbarBackground(.streamBlue.opacity(0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        // Destination
                        FeedsView()
                    } label: { // A label to show on the screen
                        Image(systemName: "chevron.backward.circle.fill")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // print("Navigates to the search page")
                        self.isShowingSearch.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")

                    }.sheet(isPresented: $isShowingSearch) {
                        SearchView(feedsClient: feedsClient)
                    }
                }
            }
            .font(.title2)
        }
    }
}

// struct ProfileUnfollower_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileUnfollower()
//            .preferredColorScheme(.dark)
//    }
// }
