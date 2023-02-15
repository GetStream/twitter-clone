//
//  SpacesCircularButton.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 9.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct SpacesCircularButton: View {
    public init() {}
    
    @Environment(\.colorScheme) var colorScheme
    
    public var body: some View {
        Button {
            
        } label: {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [colorScheme == .light ? .streamLightStart : .streamDarkStart, colorScheme == .light ? .streamLightEnd : .streamDarkEnd]), startPoint: .top, endPoint: .bottom)
                    .frame(width: 46, height: 46)
                    .clipShape(Circle())
                Image(systemName: "mic.badge.plus")
                    .symbolRenderingMode(.multicolor)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }
        }
    }
}

struct SpacesCircularButton_Previews: PreviewProvider {
    static var previews: some View {
        SpacesCircularButton()
    }
}
