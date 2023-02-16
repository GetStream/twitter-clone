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
    
    @State private var showingSheet = false
    
    public var body: some View {
        Button {
            showingSheet = true
        } label: {
            Image(systemName: "mic.badge.plus")
                .symbolRenderingMode(.multicolor)
                .font(.title3)
                .bold()
                .foregroundColor(.white)
                .frame(width: 46, height: 46)
                .background(
                    LinearGradient.blueish(for: colorScheme),
                    in: Circle()
                )
        }
        .sheet(isPresented: $showingSheet) {
            CreateSpaceView()
        }
    }
}

struct SpacesCircularButton_Previews: PreviewProvider {
    static var previews: some View {
        SpacesCircularButton()
    }
}
