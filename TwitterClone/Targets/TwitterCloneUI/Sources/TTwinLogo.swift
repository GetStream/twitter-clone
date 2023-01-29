//
//  TTwinLogo.swift
//  TTwin


import SwiftUI

public struct TTwinLogo: View {
    
    public init() {}
    
    public var body: some View {
        TwitterCloneUIAsset.twitterLogo.swiftUIImage
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 26)
            .overlay(
                TwitterCloneUIAsset.twitterLogo.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 26)
                    .offset(x: 6)
                    .blendMode(.plusDarker)
            )
    }
}

//struct TTwinLogo_Previews: PreviewProvider {
//    static var previews: some View {
//        TTwinLogo()
//            .preferredColorScheme(.dark)
//    }
//}
