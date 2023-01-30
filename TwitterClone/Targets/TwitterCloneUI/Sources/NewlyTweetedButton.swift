//
//  NewlyTweetedButton.swift
//  TwitterClone
//
//  Created by amos.gyamfi@getstream.io on 19.1.2023.
//  Copyright © 2023 Stream.io Inc.  All rights reserved.
//

import SwiftUI

public struct NewlyTweetedButton: View {
    @State private var buttonPosition = 0.0

    public init() {}

    public var body: some View {

        HStack {
            Image(systemName: "arrow.up")

            HStack(spacing: -12) {
                Image(systemName: "ant.circle.fill")
                    .zIndex(3)
                Image(systemName: "figure.run.circle.fill")
                    .zIndex(2)
                Image(systemName: "camera.macro.circle.fill")
            }
            .font(.title)
            .symbolRenderingMode(.hierarchical)

            Text("Tweeted")
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .foregroundColor(.white)
        .background(.streamBlue)
        .cornerRadius(8)
        .offset(y: buttonPosition)
        .accessibilityLabel("New Tweets")
        .accessibilityAddTraits(.isButton)
        .onAppear {
            withAnimation(.interpolatingSpring(stiffness: 75, damping: 15).delay(2).repeatCount(5)) {
                buttonPosition = -UIScreen.main.bounds.height
            }
        }

    }
}

// struct NewlyTweetedButton_Previews: PreviewProvider {
//    static var previews: some View {
//        NewlyTweetedButton()
//            .preferredColorScheme(.dark)
//    }
// }
