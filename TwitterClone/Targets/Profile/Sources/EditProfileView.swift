//
//  EditProfileView.swift
//  Profile
//
//  Created by amos.gyamfi@getstream.io on 30.1.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI
import Feeds

public struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var contentView: (() -> AnyView)
    
    var feedsClient: FeedsClient
    @State private var isCanceled = false
    @State private var isEditingMyName = "Amos Gyamfi"
    @State private var isEditingAboutMe = "#Developer #Advocate"
    @State private var isEditingMyLocation = "Mount Olive DR, Toronto ON"
    @State private var isEditingMyWebsite = "getstream.io"
    public init (feedsClient: FeedsClient, contentView: @escaping (() -> AnyView)) {
        self.feedsClient = feedsClient
        self.contentView = contentView
    }
    
    public var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        print("Open the photo picker view")
                    } label: {
                        HStack {
                            ZStack {
                                ProfileImage(imageUrl: "https://picsum.photos/id/64/200", action: {})
                                    .opacity(0.6)
                                MediaPickerView()
                            }
                            Image(systemName: "pencil")
                                .fontWeight(.bold)
                        }
                    }
                    
                    Spacer()
                }
                
                List {
                    HStack {
                        Text("Name")
                        TextField("Amos Gyamfi", text: $isEditingMyName)
                            .foregroundColor(.streamBlue)
                            .labelsHidden()
                    }
                    HStack {
                        Text("Bio")
                        TextField("Amos Gyamfi", text: $isEditingAboutMe)
                            .foregroundColor(.streamBlue)
                            .labelsHidden()
                    }
                    HStack {
                        Text("Location")
                        TextField("Amos Gyamfi", text: $isEditingMyLocation)
                            .foregroundColor(.streamBlue)
                            .labelsHidden()
                    }
                    HStack {
                        Text("Website")
                        TextField("Amos Gyamfi", text: $isEditingMyWebsite)
                            .foregroundColor(.streamBlue)
                            .labelsHidden()
                    }
                    
                }
                .listStyle(.plain)
                HStack {
                    ProfileSummaryView(contentView: contentView)
                }

            }
            .padding()
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("")
            .toolbarBackground(.streamBlue.opacity(0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        self.isCanceled.toggle()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Edit profile")
                }
            }
        }
    }
}

//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView(feedsClient: Feed)
//    }
//}
