//
//  StartView.swift
//  TTwin
//
// MARK: Create account, sign in, sign up
//

import SwiftUI
import TwitterCloneUI

public struct StartView: View {
    @State private var isLoginPresented = false
    @State private var isSignUpPresented = false

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack {
                titleView
                imageView
                createAccountButton
                orSeparatorView
                loginRowView
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TTwinLogo()
                }
            }
        }
    }

    var titleView: some View {
        Text("See what's happening in the world right now.")
            .font(.title)
            .fontWeight(.heavy)
            .multilineTextAlignment(.center)
    }

    var imageView: some View {
        AuthUIAsset.startImage.swiftUIImage
            .resizable()
            .scaledToFit()
    }

    var createAccountButton: some View {
        Button {
            self.isSignUpPresented.toggle()
        } label: {
            Label("Create account", systemImage: "plus")
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
        }
        .padding(.top)
        .buttonStyle(.bordered)
        .sheet(isPresented: $isSignUpPresented) {
            SignUpView()
        }
    }

    var orSeparatorView: some View {
        HStack {
            Rectangle()
                .frame(width: 150, height: 2)
                .foregroundColor(Color(.systemGray6))
            Text("or")
            Rectangle()
                .frame(width: 150, height: 2)
                .foregroundColor(Color(.systemGray6))
        }
    }

    var loginRowView: some View {
        HStack {
            Text("Have an account already?")
            loginButton
        }
    }

    var loginButton: some View {
        Button("Login") {
            self.isLoginPresented.toggle()
        }
        .buttonStyle(.borderedProminent)
        .tint(Color(.systemBlue))
        .sheet(isPresented: $isLoginPresented) {
            LogInView()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .preferredColorScheme(.dark)
    }
}
