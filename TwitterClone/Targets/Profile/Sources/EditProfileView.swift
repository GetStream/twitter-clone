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
    @EnvironmentObject var feedsClient: FeedsClient
    @EnvironmentObject var profileInfoViewModel: ProfileInfoViewModel
    @StateObject var mediaPickerViewModel = MediaPickerViewModel()
    
    @State private var feedUser: FeedUser

    public init (currentUser: FeedUser) {
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
                        Text("First Name")
                        TextField("First Name", text: $feedUser.firstname)
                            .foregroundColor(.streamBlue)
                            .labelsHidden()
                    }
                    HStack {
                        Text("Last Name")
                        TextField("Last Name", text: $feedUser.lastname)
                            .foregroundColor(.streamBlue)
                            .labelsHidden()
                    }
                    HStack {
                        Text("Bio")
                        TextField("Bio", text: $feedUser.aboutMe)
                            .foregroundColor(.streamBlue)
                            .labelsHidden()
                    }
                    HStack {
                        Text("Location")
                        TextField("location", text: $feedUser.location)
                            .foregroundColor(.streamBlue)
                            .labelsHidden()
                    }
                    
                }
                .font(.footnote)
                .listStyle(.plain)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .toolbarBackground(.streamBlue.opacity(0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
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
