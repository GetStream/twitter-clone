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
    
    @Environment(\.dismiss) var dismiss

    public var body: some View {
        NavigationStack {
            VStack {
                contentView()
            } // All views
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Link to the full profile page: MyProfile.swift
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.2")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Dismiss sheet
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
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
