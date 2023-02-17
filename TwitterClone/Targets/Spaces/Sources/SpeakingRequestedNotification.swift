//
//  SpeakingRequestedNotification.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 16.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct SpeakingRequestedNotification: View {
    public init() {}
    @Environment(\.colorScheme) var colorScheme
    @State private var requestSent = false
    
    public var body: some View {
        ZStack(alignment: .leading) {
            LinearGradient(gradient: Gradient(colors: [colorScheme == .light ? .streamLightStart : .streamDarkStart, colorScheme == .light ? .streamLightEnd : .streamDarkEnd]), startPoint: .top, endPoint: .bottom)
                .frame(width: UIScreen.main.bounds.width - 120, height: 48)
                .cornerRadius(12)
            
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                Text("Request sent to the host")
            }
            .foregroundColor(.white)
            .padding(.horizontal)
        }
        .offset(y: requestSent ? UIScreen.main.bounds.height / 9 - 500 : -UIScreen.main.bounds.height)
        .onAppear {
            withAnimation(.spring()) {
                requestSent.toggle()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    requestSent = false
                }
            }
        }
    }
}

struct SpeakingRequestedNotification_Previews: PreviewProvider {
    static var previews: some View {
        SpeakingRequestedNotification()
    }
}
