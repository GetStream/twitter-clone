//
//  MyProfile.swift
//  TwitterClone
//

import SwiftUI

import TwitterCloneUI
import Feeds

public struct MyProfile: View {
    @EnvironmentObject var feedsClient: FeedsClient
    @State private var isShowingSearch = false

    private var contentView: (() -> AnyView)
    
    public init (contentView: @escaping (() -> AnyView)) {
        self.contentView = contentView
    }

    public var body: some View {
        NavigationStack {
            VStack {
                contentView()
            } // All views
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("")
            .toolbarBackground(.streamBlue.opacity(0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Link to the full profile page: MyProfile.swift
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear.circle.fill")
                    }
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
