//
//  SignUp.swift
//  TwitterClone
//
// MARK: Create a new account

import SwiftUI

import TwitterCloneUI
import Feeds
import Auth

public struct SignUp: View {
    @EnvironmentObject var feedsClient: FeedsClient
    @EnvironmentObject var auth: TwitterCloneAuth
    @Environment(\.presentationMode) var presentationMode

    @State private var username = ""
    @State private var password = ""
    @State private var firstname = ""
    @State private var lastname = ""

    public var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Username", text: $username)
                        // .textFieldStyle(.roundedBorder)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                        SecureField("Password", text: $password)
                        // .textFieldStyle(.roundedBorder)
                            .textContentType(.password)
                        TextField("Firstname", text: $firstname)
                        TextField("Lastname", text: $lastname)

                    } header: {
                        Text("Create your account")
                    }
                }
                .frame(height: 232)
                .cornerRadius(16)

                AsyncButton("Sign up") {
                    do {
                        let authUser = try await auth.signup(username: username, password: password)
                        let user = NewFeedUser(userId: authUser.userId, firstname: firstname, lastname: lastname, username: username, profilePicture: nil)
                        _ = try await feedsClient.createUser(user)
                        try await feedsClient.follow(target: user.userId, activityCopyLimit: 10)
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.streamBlue)
                .disabled(username.isEmpty || password.isEmpty || firstname.isEmpty || lastname.isEmpty)
                Spacer()
            }
            .padding(16)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Sign up")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        // Destination: Go to the create account page
                       StartView()
                    } label: { // A label to show on the screen
                        Image(systemName: "chevron.backward.circle.fill")
                    }
                }

                ToolbarItem(placement: .principal) {
                    TTwinLogo()
                }
            }
        }
    }
}

// struct SignUp_Previews: PreviewProvider {
//    static let auth = TwitterCloneAuth()
//    static var previews: some View {
//        SignUp()
//            .environmentObject(auth)
//    }
// }
