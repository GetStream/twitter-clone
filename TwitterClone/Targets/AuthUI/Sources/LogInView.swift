//
//  LogInView.swift
//  TTwin
//
//  Created by amos.gyamfi@getstream.io on 14.1.2023.
//

import SwiftUI

import TwitterCloneUI
import Feeds
import Auth

public struct LogInView: View {
    @EnvironmentObject var feedsClient: FeedsClient
    @EnvironmentObject var auth: TwitterCloneAuth
    @Environment(\.presentationMode) var presentationMode

    @State private var username = ""
    @State private var password = ""

    public var body: some View {
        PopoverView(title: "Login") {
            loginContent
        }
    }

    @ViewBuilder
    var loginContent: some View {
        VStack {
            Form {
                Section {
                    usernameTextField
                    passwordTextField
                } header: {
                    Text("Please enter your login credentials")
                }
            }
            .frame(height: 148)
            .cornerRadius(16)

            loginButton

            Spacer()
        }
        .padding(16)
    }

    var usernameTextField: some View {
        TextField("Your username", text: $username)
            .textContentType(.username)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .keyboardType(.emailAddress)
    }

    var passwordTextField: some View {
        SecureField("Your password", text: $password)
            .textContentType(.password)
    }

    var loginButton: some View {
        AsyncButton("Log In") {
            do {
                try await auth.login(username: username, password: password)

                presentationMode.wrappedValue.dismiss()
            } catch {
                print(error)
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(username.isEmpty || password.isEmpty)
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
