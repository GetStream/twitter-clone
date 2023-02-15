//
//  SpacesReactionAnimation.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 14.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct SpacesReactionAnimation: View {
    public init() {}
    @State private var isEnlarging = false
    @State private var isMoving = false
    @State private var isDisappearing = false
    
    public var body: some View {
       Image("100Percent")
            .resizable()
            .scaledToFit()
            .frame(width: 38, height: 38)
            .padding(8)
            .background(Color(.systemGray6))
            .clipShape(Circle())
            .scaleEffect(isEnlarging ? 1 : 0)
            .scaleEffect(isMoving ? 0.5 : 1)
            .opacity(isDisappearing ? 0 : 1)
            .offset(x: isMoving ? 27 : 0, y: isMoving ? -27 : 0)
            .onAppear {
                withAnimation(.spring()) {
                    isEnlarging.toggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.spring()) {
                        isMoving.toggle()
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                    withAnimation(.spring()) {
                        isDisappearing.toggle()
                    }
                }
            }
    }
}

struct SpacesReactionAnimation_Previews: PreviewProvider {
    static var previews: some View {
        SpacesReactionAnimation()
    }
}
