//
//  LinearGradient+Constants.swift
//  Spaces
//
//  Created by Stefan Blos on 16.02.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

extension LinearGradient {
    
    static func blueish(for colorScheme: ColorScheme) -> LinearGradient {
        LinearGradient(gradient: Gradient(colors: [colorScheme == .light ? .streamLightStart : .streamDarkStart, colorScheme == .light ? .streamLightEnd : .streamDarkEnd]), startPoint: .top, endPoint: .bottom)
    }
    
    static var spaceish = LinearGradient(
        gradient: Gradient(colors: [.spacesBlue, .spacesViolet]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
}
