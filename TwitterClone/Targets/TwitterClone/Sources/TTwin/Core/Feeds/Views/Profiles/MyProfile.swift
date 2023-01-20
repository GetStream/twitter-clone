//
//  MyProfile.swift
//  TwitterClone
//

import SwiftUI

struct MyProfile: View { @State private var selection = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                ProfileInfoAndTweets()
                TabBarView()
                    .frame(height: 68)
            } // All views
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("")
            .toolbarBackground(.streamBlue.opacity(0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .padding()
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                            // Destination
                            HomeTimelineView()
                        } label: { // A label to show on the screen
                            Image(systemName: "chevron.backward.circle.fill")
                        }
                    /*Button{
                        print("got back home to For You and Following Tweets")
                    } label: {
                        Image(systemName: "arrow.backward.circle.fill")
                    }*/
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(){
                        print("Navigates to the search page")
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                    }
                }
            }
            .font(.title2)
        }
    }
}

struct MyProfile_Previews: PreviewProvider {
    static var previews: some View {
        MyProfile()
            .preferredColorScheme(.dark)
    }
}
