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
    @EnvironmentObject var profileInfoViewModel: ProfileInfoViewModel
    @StateObject var mediaPickerViewModel = MediaPickerViewModel()
    
    @State var feedUser: FeedUser
    
    var feedsClient: FeedsClient
    @State private var isEditingMyName = "Amos Gyamfi"
    @State private var isEditingAboutMe = "#Developer #Advocate"
    @State private var isEditingMyLocation = "Mount Olive DR, Toronto ON"
    @State private var isEditingMyWebsite = "getstream.io"
    public init (feedsClient: FeedsClient, currentUser: FeedUser) {
        self.feedsClient = feedsClient
        _feedUser = State(initialValue: currentUser)
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
                                ProfileImage(imageUrl: feedUser.profilePicture, action: {})
                                    .opacity(0.6)
                                MediaPickerView(viewModel: mediaPickerViewModel)
                            }
                            Image(systemName: "pencil")
                                .fontWeight(.bold)
                        }
                    }
                    
                    Spacer()
                }
                
                List {
                    HStack {
                        Text("Firstname")
                        TextField("firstname", text: $feedUser.firstname)
                            .foregroundColor(.streamBlue)
                            .labelsHidden()
                    }
                    HStack {
                        Text("Lastname")
                        TextField("lastname", text: $feedUser.lastname)
                            .foregroundColor(.streamBlue)
                            .labelsHidden()
                    }
                    HStack {
                        Text("Bio")
                        TextField("Bio", text: $feedUser.aboutMe)
                            .foregroundColor(.streamBlue)
                            .labelsHidden()
                    }
//                    HStack {
//                        Text("Location")
//                        TextField("location", text: $feedUser.location)
//                            .foregroundColor(.streamBlue)
//                            .labelsHidden()
//                    }
//                    HStack {
//                        Text("Website")
//                        TextField("website", text: $feedUser.website)
//                            .foregroundColor(.streamBlue)
//                            .labelsHidden()
//                    }
                    
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("")
            .toolbarBackground(.streamBlue.opacity(0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Ok") {
                        Task {
                            if let mimeType = mediaPickerViewModel.mimetype, let imageData = mediaPickerViewModel.imageData {
                                let profileImageUrl = try await feedsClient.uploadImage(fileName: "profile_image",
                                                                                        mimeType: mimeType,
                                                                                        imageData: imageData)
                                feedUser.profilePicture = profileImageUrl.absoluteString
                            }
                            try await feedsClient.updateUser(feedUser)
                            profileInfoViewModel.feedUser = feedUser
                            presentationMode.wrappedValue.dismiss()
                        }
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
