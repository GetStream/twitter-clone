//
//  ProfileSummaryView.swift
//  TwitterCloneUI
//
//  Created by amos.gyamfi@getstream.io on 30.1.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI
import Feeds

public struct ProfileSummaryView: View {
    @EnvironmentObject var profileInfoViewModel: ProfileInfoViewModel

    @State private var isEditingPresented = false
    
    private var contentView: (() -> AnyView)
    public init (contentView: @escaping (() -> AnyView)) {
        self.contentView = contentView
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            List {
                // Link to the full profile page: MyProfile.swift
                NavigationLink {
                    MyProfile(contentView: contentView)
                } label: {
                    Image(systemName: "person.circle.fill")
                    Text("View full profile")
                }

                // Link to the full profile page: MyProfile.swift
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gear.circle.fill")
                    Text("Settings")
                }
            }
            .listStyle(.plain)
            
            Spacer()
        }
        .padding()
    }
}
