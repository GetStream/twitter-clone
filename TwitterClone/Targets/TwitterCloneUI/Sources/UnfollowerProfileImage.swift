//
//  UnfollowerProfileImage.swift
//  TTwin
//
//  Pulls Unsplash images through Picsum
//

import SwiftUI

public struct UnfollowerProfileImage: View {
    public init(){}
    
    public var body: some View {
        AsyncImage(url: URL(string: "https://picsum.photos/id/152/200")) { loading in
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

//struct UnfollowerProfileImage_Previews: PreviewProvider {
//    static var previews: some View {
//        UnfollowerProfileImage()
//            .preferredColorScheme(.dark)
//    }
//}
