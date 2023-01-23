//
//  StartView.swift
//  TTwin
//
//  MARK: Create account, sign in, sign up
//

import SwiftUI
import TwitterCloneAuth

struct StartView: View {
    @EnvironmentObject var auth: TwitterCloneAuth
    
    var body: some View {
        VStack {
            // TwitterClone Logo
            TTwinLogo()
            
            Spacer()
            
            Text("See what's happening in the world right now.")
                .font(.title)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            // Button with image and label
            Button {
                SignInWithGoogle()
            } label: {
                Label("Continue with Google", image: "googleLogoSmall")
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            }.buttonStyle(.bordered)
            
            Button {
                SignInWithApple()
            } label: {
                Label("Continue with Apple", systemImage: "applelogo")
                    .padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24))
            }.buttonStyle(.bordered)
            
            HStack {
                Rectangle()
                    .frame(width: .infinity, height: 1)
                    .foregroundColor(Color(.systemGray6))
                Text("or")
                Rectangle()
                    .frame(width: .infinity, height: 1)
                    .foregroundColor(Color(.systemGray6))
            }
            
            Button {
                SignInWithApple()
            } label: {
                Label("Create account", systemImage: "plus")
                    .padding(EdgeInsets(top: 16, leading: 42, bottom: 16, trailing: 42))
            }.buttonStyle(.bordered)
            
            Spacer()
            
            HStack {
                Text("Have an account already?")
                Button("Login") {
                    LogIn()
                }
                .buttonStyle(.automatic)
                .tint(Color(.systemBlue))
            }
        }.padding()
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .preferredColorScheme(.dark)
    }
}
