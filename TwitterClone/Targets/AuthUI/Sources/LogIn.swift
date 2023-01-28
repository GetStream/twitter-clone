//
//  LogIn.swift
//  TTwin
//
//  Created by amos.gyamfi@getstream.io on 14.1.2023.
//

import SwiftUI

import TwitterCloneUI
import Auth

public struct LogIn: View {
    @EnvironmentObject var auth: TwitterCloneAuth
    @Environment(\.presentationMode) var presentationMode
    
    @State private var username = ""
    @State private var password = ""
    
    public var body: some View {
        NavigationStack{
            VStack {
                Form {
                    Section {
                        TextField("Your username", text: $username)
                        //.textFieldStyle(.roundedBorder)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                        SecureField("Your password", text: $password)
                        //.textFieldStyle(.roundedBorder)
                            .textContentType(.password)
                    } header: {
                        Text("Please enter your login credentials")
                    }
                }
                .frame(height: 148)
                .cornerRadius(16)
                
                AsyncButton("Log In") {
                    do {
                        try await auth.login(username: username, password: password)
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error)
                    }
                }
                .buttonStyle(.borderedProminent)
//                .tint(.streamBlue)
                .disabled(username.isEmpty || password.isEmpty)
                Spacer()
            }
            .padding(16)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Log in")
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

struct LogIn_Previews: PreviewProvider {
    static let auth = TwitterCloneAuth()
    static var previews: some View {
        LogIn()
            .environmentObject(auth)
    }
}
