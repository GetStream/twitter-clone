//
//  TTwinLogo.swift
//  TTwin


import SwiftUI

struct TTwinLogo: View {
    var body: some View {
        Image("twitterLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 26)
            .overlay(
                Image("twitterLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 26)
                    .offset(x: 6)
                    .blendMode(.plusDarker)
            )
    }
}

struct TTwinLogo_Previews: PreviewProvider {
    static var previews: some View {
        TTwinLogo()
            .preferredColorScheme(.dark)
    }
}
