//
//  MyProfileImage.swift
//  TTwin
//
//  Pulls Unsplash images through Picsum
//

import SwiftUI

struct MyProfileImage: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://picsum.photos/id/64/200")) { loading in
            if let image = loading.image {
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
            } else if loading.error != nil {
                Text("There was an error loading the profile image.")
            } else {
                ProgressView()
            }
        }
        .frame(width: 48, height: 48)
        .accessibilityLabel("Profile photo")
        .accessibilityAddTraits(.isButton)
    }
}

struct MyProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileImage()
            .preferredColorScheme(.dark)
    }
}
