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
    
    public var body: some View {
        Button {
            
        } label: {
            ZStack {
                Circle()
                    .frame(width: 46, height: 46)
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
