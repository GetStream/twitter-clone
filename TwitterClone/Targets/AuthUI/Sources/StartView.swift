//
//  StartView.swift
//  TTwin
//
// MARK: Create account, sign in, sign up
//

import SwiftUI
import TwitterCloneUI
import Feeds

public struct StartView: View {
    @EnvironmentObject var feedsClient: FeedsClient
    @State private var isPresented = false
    @State private var isShown = false

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack {
                Text("See what's happening in the world right now.")
                    .font(.title)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)

                AuthUIAsset.startImage.swiftUIImage
                    .resizable()
                    .scaledToFit()

                Button {
                    self.isShown.toggle()
                } label: {
                    Label("Create account", systemImage: "plus")
                        .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                }
                .padding(.top)
                .buttonStyle(.bordered)
                // .fullScreenCover(isPresented: $isShown, content: SignUp.init)
                .sheet(isPresented: $isShown, content: SignUp.init)

                // Button with image and label
                HStack {
                    Rectangle()
                        .frame(width: 150, height: 2)
                        .foregroundColor(Color(.systemGray6))
                    Text("or")
                    Rectangle()
                        .frame(width: 150, height: 2)
                        .foregroundColor(Color(.systemGray6))
                }

                HStack {
                    Text("Have an account already?")
                    Button("Login") {
                        self.isPresented.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(.systemBlue))
                    .sheet(isPresented: $isPresented, content: LogIn.init)
                }

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
}

// struct StartView_Previews: PreviewProvider {
//    static let auth = TwitterCloneAuth()
//    static var previews: some View {
//        StartView()
//            .environmentObject(auth)
//            .preferredColorScheme(.dark)
//    }
// }
