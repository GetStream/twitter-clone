//
//  MyProfile.swift
//  TwitterClone
//

import SwiftUI

import TwitterCloneUI
import Feeds

public struct ProfileFollower: View { @State private var selection = 0
    @Environment(\.presentationMode) var presentationMode
    
    var contentView: (() -> AnyView)

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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: { // A label to show on the screen
                            Image(systemName: "chevron.backward.circle.fill")
                    }
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
