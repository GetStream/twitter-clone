//
//  SpacesLiveView.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 8.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TimelineUI
import AuthUI

public struct SpacesLiveView: View {
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                SoundIndicatorView()
                    .scaleEffect(0.5)
                Text("LIVE")
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding()
            
            Text("The iOS Talk Show 👩‍💻")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            HStack {
                HStack(spacing: -20) {
                    Image("thierry")
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFit()
                        .frame(width: 42, height: 42)
                        .zIndex(3)
                    Image("zoey")
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFit()
                        .frame(width: 42, height: 42)
                        .zIndex(2)
                    Image("nash")
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFit()
                        .frame(width: 42, height: 42)
                        .zIndex(1)
                }
                Text("89 listening")
            }.padding(.horizontal)
            
            HStack {
                Image("profile5")
                    .padding()
                Text("Jeroen Lenarts")
                Image(systemName: "checkmark.seal.fill")
                Text("Host")
                    .padding(.horizontal, 8)
                    .background(.streamBlue)
                    .cornerRadius(4)
               
                Spacer()
            }
            .background(.streamBlue.opacity(0.5))
        }
        .background(.streamBlue.opacity(0.5))
        .cornerRadius(12)
    }
}

struct SpacesLiveView_Previews: PreviewProvider {
    static var previews: some View {
        SpacesLiveView()
    }
}
