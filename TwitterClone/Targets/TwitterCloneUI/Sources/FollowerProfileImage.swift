//
//  MyProfileImage.swift
//  TTwin
//
//  Pulls Unsplash images through Picsum
//

import SwiftUI

struct FollowerProfileImage: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://picsum.photos/id/237/200")) { loading in
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

struct FollowerProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        FollowerProfileImage()
            .preferredColorScheme(.dark)
    }
}
