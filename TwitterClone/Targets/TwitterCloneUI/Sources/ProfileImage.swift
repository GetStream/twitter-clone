//
//  ProfileImage.swift
//

import SwiftUI

public struct ProfileImage: View {
    public init (imageUrl: String?, action: (() -> Void)?) {
        self.action = action
        self.imageUrl = imageUrl
    }
    
    var imageUrl: String?
    var action: (() -> Void)?

    public var body: some View {
        if let action {
            Button {
                action()
            } label: {
                profileImage
            }
            .buttonStyle(.borderless)
        } else {
            profileImage
        }
    }
    
    @ViewBuilder
    private var profileImage: some View {
        if let imageUrl {
            AsyncImage(url: URL(string: imageUrl)) { loading in
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
        } else {
            Image(systemName: "person.circle")
                .scaleEffect(1.5)
                .frame(width: 48, height: 48)
                .accessibilityLabel("Profile photo")
        }
    }
}

// struct ProfileImage_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileImage()
//            .preferredColorScheme(.dark)
//    }
// }
