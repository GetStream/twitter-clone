//
//  EditPassword.swift
//  Profile
//
//  Created by amos.gyamfi@getstream.io on 1.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct EditPassword: View {
    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var isShowingEditPassword = false
    public init () {}
    
    public var body: some View {
        NavigationStack {
            Form {
                Section{
                    TextField("Current password", text: $oldPassword)
                        .keyboardType(.twitter)
                } header: {
                    Text("Current password")
                }
                
                Section{
                    TextField("At least 6 characters", text: $newPassword)
                        .keyboardType(.twitter)
                } header: {
                    Text("New password")
                }
                
                Section{
                    TextField("At least 6 characters", text: $confirmPassword)
                        .keyboardType(.twitter)
                } header: {
                    Text("Confirm password")
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(role: .cancel) {
                        self.isShowingEditPassword.toggle()
                    } label: {
                        Text("Cancel")
                    }
                    .fullScreenCover(isPresented: $isShowingEditPassword, content: SettingsView.init)
                    
                }
                
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Edit password")
                        Text("@stefanjblos")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingEditPassword.toggle()
                    } label: {
                        Text("Done")
                    }
                    .disabled(newPassword.isEmpty)
                }
            }
        }
    }
}

struct EditPassword_Previews: PreviewProvider {
    static var previews: some View {
        EditPassword()
    }
}
