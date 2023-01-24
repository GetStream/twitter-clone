//
//  LogIn.swift
//  TTwin
//
//  Created by amos.gyamfi@getstream.io on 14.1.2023.
//

import SwiftUI
import TwitterCloneUI
import TwitterCloneAuth

struct LogIn: View {
    @EnvironmentObject var auth: TwitterCloneAuth
    @Environment(\.presentationMode) var presentationMode
    
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Text("Please enter your login credentials")
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .textContentType(.username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .textContentType(.password)
            AsyncButton("Log In") {
                do {
                    try await auth.login(username: username, password: password)
                    presentationMode.wrappedValue.dismiss()
                } catch {
                    print(error)
                }
            }
            .buttonStyle(.automatic)
            .tint(Color(.systemBlue))
            .frame(width: 120.0, height: 60.0)
            .disabled(username.isEmpty || password.isEmpty)
            Spacer()
        }.padding(16)
    }
}

struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        LogIn()
    }
}
