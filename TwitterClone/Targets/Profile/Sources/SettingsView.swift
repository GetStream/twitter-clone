//
//  SettingsView.swift
//  TwitterCloneUI
//
//  Created by amos.gyamfi@getstream.io on 30.1.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI
import AuthUI
import Auth
import Feeds
import Chat
import DirectMessages
import RevenueCat

public struct SettingsView: View {
    @EnvironmentObject var feedsClient: FeedsClient
    @EnvironmentObject var auth: TwitterCloneAuth
    @EnvironmentObject var chatModel: ChatModel
    @EnvironmentObject var purchaseViewModel: PurchaseViewModel
    @EnvironmentObject var profileInfoViewModel: ProfileInfoViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var mediaPickerViewModel = MediaPickerViewModel()
    
    @State private var currentFirstName: String = ""
    @State private var currentLastName: String = ""
    @State private var currentUsername: String = ""
    @State private var isEditingUserName = false
    @State private var isEditingPassword = false

    public init () {}
    
    public var body: some View {
        NavigationStack {
            List {
                profilePhotoRow
                firstNameRow
                lastNameRow
                usernameRow
                passwordRow
                subscriptionRow
            }
            .listStyle(.plain)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxHeight: 280)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Your acount settings")
                }
            }
            
            Button(role: .destructive) {
                presentationMode.wrappedValue.dismiss()
                auth.logout()
//                chatModel.logout()
            } label: {
                Image(systemName: "power.circle.fill")
                Text("Log out")
            }
            
            Spacer()
        }
        .task {
            currentFirstName = profileInfoViewModel.firstname
            currentLastName = profileInfoViewModel.lastname
        }
    }

    var profilePhotoRow: some View {
        HStack {
            Button {
                print("Open the photo picker")
            } label: {
                HStack {
                    ZStack {
                        ProfileImage(imageUrl: profileInfoViewModel.profilePictureUrlString, action: {})
                            .opacity(0.6)
                        MediaPickerView(viewModel: mediaPickerViewModel)
                    }
                    Image(systemName: "pencil")
                        .fontWeight(.bold)
                }
            }

            Spacer()
        }
    }

    var firstNameRow: some View {
        HStack {
            Text("Change your first name")
            Spacer()
            TextField("Enter a first name", text: $currentFirstName)
                .foregroundColor(.streamBlue)
                .labelsHidden()
        }
    }

    var lastNameRow: some View {
        HStack {
            Text("Change your last name")
            Spacer()
            TextField("Enter a last name", text: $currentLastName)
                .foregroundColor(.streamBlue)
                .labelsHidden()
        }
    }

    var usernameRow: some View {
        NavigationLink {
            EditUserName()
        } label: {
            Button {
                self.isEditingUserName.toggle()
            } label: {
                HStack {
                    Text("Change your username")
                    Spacer()
                    Text(currentUsername)
                }
            }
        }
    }

    var passwordRow: some View {
        NavigationLink {
            EditPassword(auth: auth)
        } label: {
            Button {
                self.isEditingPassword.toggle()
            } label: {
                HStack {
                    Text("Change your password")
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    var subscriptionRow: some View {
        if purchaseViewModel.isSubscriptionActive {
            Text("You are subscribed")
                .padding(.top)
        } else {
            if let packages = purchaseViewModel.offerings?.current?.availablePackages {
                ForEach(packages) { package in
                    SubscribeBlue(package: package)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let profileInfoViewModel = ProfileInfoViewModel(feedUser: FeedUser.previewUser())
    // swiftlint:disable:next force_try
    static let auth = try! TwitterCloneAuth(baseUrl: "http://localhost:8080")
    static let purchaseViewModel = PurchaseViewModel()

    static var previews: some View {
        SettingsView()
            .environmentObject(profileInfoViewModel)
            .environmentObject(auth)
            .environmentObject(purchaseViewModel)
    }
}
