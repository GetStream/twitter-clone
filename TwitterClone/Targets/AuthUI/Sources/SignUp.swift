//
//  SignUp.swift
//  TwitterClone
//
//  MARK: Create a new account

import SwiftUI
import TwitterCloneUI
import Auth

public struct SignUp: View {
    @EnvironmentObject var auth: TwitterCloneAuth
    @Environment(\.presentationMode) var presentationMode
    
    @State private var username = ""
    @State private var password = ""
    
    public var body: some View {
        NavigationStack{
            VStack {
                Form {
                    Section {
                        TextField("Username", text: $username)
                        //.textFieldStyle(.roundedBorder)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                        SecureField("Password", text: $password)
                        //.textFieldStyle(.roundedBorder)
                            .textContentType(.password)
                    } header: {
                        Text("Create your account")
                    }
                }
                .frame(height: 148)
                .cornerRadius(16)
                
                AsyncButton("Sign up") {
                    do {
                        try await auth.signup(username: username, password: password)
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.streamBlue)
                .disabled(username.isEmpty || password.isEmpty)
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

struct SignUp_Previews: PreviewProvider {
    static let auth = TwitterCloneAuth()
    static var previews: some View {
        SignUp()
            .environmentObject(auth)
    }
}
