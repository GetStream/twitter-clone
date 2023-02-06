//
//  RetweetAnimationView.swift
//  TwitterClone
//
//  Created by amos.gyamfi@getstream.io on 3.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct RetweetAnimationView: View {
    @State private var notRetweeted = false
    @State private var numberOfRetweets = 20
    let animationDuration: Double = 0.1
    public init() {}
    
    public var body: some View {
        HStack {
            Button {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
                    notRetweeted.toggle()
                        if notRetweeted {
                            numberOfRetweets += 1
                        } else {
                            numberOfRetweets -= 1
                        }
                }
            } label: {
                Image(systemName: "arrow.2.squarepath")
                    .rotationEffect(.degrees(notRetweeted ? 90 : 0))
                Text("\(numberOfRetweets)")
            }
            .font(notRetweeted ? .title3 : .headline)
            .foregroundColor(notRetweeted ? Color(.systemPink) : Color(.systemGray))
        }
    }
}

struct RetweetAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        RetweetAnimationView()
    }
}
