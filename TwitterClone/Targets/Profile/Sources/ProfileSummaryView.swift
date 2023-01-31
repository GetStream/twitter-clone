//
//  ProfileSummaryView.swift
//  TwitterCloneUI
//
//  Created by amos.gyamfi@getstream.io on 30.1.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI

public struct ProfileSummaryView: View {
    @State private var isEditingPresented = false
    public init () {}

    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                ProfileInfoView(myProfile: myProfileData)
                    .padding(.top)

                // Link to the full profile page: MyProfile.swift
                NavigationLink {
                    MyProfile()
                } label: {
                    Image(systemName: "person.circle.fill")
                    Text("View full profile")
                }

                // Link to the full profile page: MyProfile.swift
                NavigationLink {
                    MyProfile()
                } label: {
                    Image(systemName: "gear.circle.fill")
                    Text("Settings")
                }

                Spacer()
            }
            .padding()
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    MyProfileImage()
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.isEditingPresented.toggle()
                    } label: {
                        Text("Edit profile")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $isEditingPresented, content: EditProfileView.init)
                }
            }
        }
    }
}

struct ProfileSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummaryView()
    }
}