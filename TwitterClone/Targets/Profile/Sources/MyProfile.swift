//
//  MyProfile.swift
//  TwitterClone
//

import SwiftUI

import TwitterCloneUI
import Timeline
import Search

public struct MyProfile: View {
    @State private var selection = 0
    @State private var isShowingSearch = false
    public init () {}

    public var body: some View {
        NavigationStack {
            VStack {
                MyProfileInfoAndTweets()
                TabBarView()
                    .frame(height: 68)
            } // All views
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("")
            .toolbarBackground(.streamBlue.opacity(0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .padding()
            .toolbar {
                /*ToolbarItem(placement: .navigationBarLeading) {
                 NavigationLink {
                 // Destination
                 HomeTimelineView()
                 } label: { // A label to show on the screen
                 Image(systemName: "chevron.backward.circle.fill")
                 }
                 }*/

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

// struct MyProfile_Previews: PreviewProvider {
//    static var previews: some View {
//        MyProfile()
//            .preferredColorScheme(.dark)
//    }
// }
