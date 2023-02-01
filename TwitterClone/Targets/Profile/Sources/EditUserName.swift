//
//  EditUserName.swift
//  Profile
//
//  Created by amos.gyamfi@getstream.io on 1.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct EditUserName: View {
    @State private var updateUseName = ""
    @State private var isShowingsettings = false
    public init () {}
    
    public var body: some View {
        NavigationStack {
            Form {
                Section{
                    Text("stefanjblos")
                } header: {
                    Text("Current username")
                }
                
                Section{
                    TextField("username", text: $updateUseName)
                        .keyboardType(.twitter)
                } header: {
                    Text("New username")
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(role: .cancel) {
                        self.isShowingsettings.toggle()
                    } label: {
                        Text("Cancel")
                    }
                    .fullScreenCover(isPresented: $isShowingsettings, content: SettingsView.init)
                    
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Edit username")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.isShowingsettings.toggle()
                    } label: {
                        Text("Done")
                    }
                    .disabled(updateUseName.isEmpty)
                }
            }
        }
    }
}

struct EditUserName_Previews: PreviewProvider {
    static var previews: some View {
        EditUserName()
    }
}
