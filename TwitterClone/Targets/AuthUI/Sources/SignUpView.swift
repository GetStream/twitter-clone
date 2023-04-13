//
//  SignUpView.swift
//  TwitterClone
//
// MARK: Create a new account

import SwiftUI

import TwitterCloneUI
import Feeds
import Auth

public struct SignUpView: View {
    @EnvironmentObject var auth: TwitterCloneAuth
    @Environment(\.presentationMode) var presentationMode

    @State private var username = ""
    @State private var password = ""
    @State private var firstname = ""
    @State private var lastname = ""

    public var body: some View {
        PopoverView(title: "Sign Up") {
            signUpContent
        }
    }

    var signUpContent: some View {
        VStack {
            Form {
                Section {
                    usernameTextField
                    passwordTextField
                    firstNameTextField
                    lastNameTextField
                } header: {
                    Text("Create your account")
                }
            }
            .frame(height: 232)
            .cornerRadius(16)

            signUpButton

            Spacer()
        }
        .padding(16)
    }

    var usernameTextField: some View {
        TextField("Username", text: $username)
            .textContentType(.username)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .keyboardType(.emailAddress)
    }

    var passwordTextField: some View {
        SecureField("Password", text: $password)
            .textContentType(.password)
    }

    var firstNameTextField: some View {
        TextField("First Name", text: $firstname)
            .textContentType(.givenName)
    }

    var lastNameTextField: some View {
        TextField("Last Name", text: $lastname)
            .textContentType(.familyName)
    }

    var signUpButton: some View {
        AsyncButton("Sign up") {
            do {
                let authUser = try await auth.signup(username: username, password: password)
                let user = NewFeedUser(userId: authUser.userId, firstname: firstname, lastname: lastname, username: username, profilePicture: nil)
                let feedsClient = FeedsClient.productionClient(authUser: authUser)
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
    }
}

 struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
 }
