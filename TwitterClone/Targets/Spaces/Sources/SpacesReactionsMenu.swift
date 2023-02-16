//
//  SpacesReactionsMenu.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 13.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct SpacesReactionsMenu: View {
    
    public init() {}
    
    public var body: some View {
        Grid {
            GridRow {
                Image("darkHandsUp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                Image("heartSparkle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                Image("loveEmoji")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                Image("starsOnFace")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                
                Image("100Percent")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            
            GridRow {
                Image("happyEmoji")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                Image("revolvingHeart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                Image("yellowHeart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                Image("tearsOfJoy1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                Image("handsUp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct SpacesReactionsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SpacesReactionsMenu()
    }
}
