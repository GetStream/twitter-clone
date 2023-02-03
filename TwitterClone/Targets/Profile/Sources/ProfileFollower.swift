//
//  MyProfile.swift
//  TwitterClone
//

import SwiftUI

import Search
import TwitterCloneUI
import TimelineUI

public struct ProfileFollower: View { @State private var selection = 0
    @State private var isShowingSearch = false

    public init () {}
    
    public var body: some View {
        NavigationStack {
            VStack {
                FollowerProfileInfoAndTweets()
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

                    }.sheet(isPresented: $isShowingSearch, content: SearchView.init)
                }
            }
            .font(.title2)
        }
    }
}

// struct ProfileFollower_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileFollower()
//            .preferredColorScheme(.dark)
//    }
// }
