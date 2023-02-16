//
//  SpaceCard.swift
//  Spaces
//
//  Created by Stefan Blos on 16.02.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI

struct SpaceCard: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var space: Space
    
    var body: some View {
        Button {
//            isShowingSpacesStartListening.toggle()
        } label: {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    SoundIndicatorView()
                        .scaleEffect(0.3)
                    Text(space.state.cardString)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                Text(space.name)
                    .font(.title3)
                    .bold()
                    .padding(.horizontal)
                    .foregroundColor(.white)
                
                HStack {
                    HStack(spacing: -20) {
                        ForEach(space.listeners.prefix(3), id: \.self) { listener in
                            // TODO: show image of users
                        }
                    }
                    Text("\(space.listeners.count) listening")
                        .font(.caption)
                        .foregroundColor(.white)
                }.padding(.horizontal)
                
                HStack {
                    Image("profile5")
                        .padding()
                    Text(space.host)
                        .font(.footnote)
                    Image(systemName: "checkmark.seal.fill")
                    Text("Host")
                        .font(.footnote)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.streamBlue)
                        .cornerRadius(4)
                    
                    Spacer()
                }
                .foregroundColor(.white)
                .background(colorScheme == .light ? .lowerBarLight : .lowerBarDark)
            }
            .background(LinearGradient(gradient: Gradient(colors: [colorScheme == .light ? .streamLightStart : .streamDarkStart, colorScheme == .light ? .streamLightEnd : .streamDarkEnd]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
//        .sheet(isPresented: $isShowingSpacesStartListening) {
//            SpacesStartListeningView(viewModel: viewModel)
//                .presentationDetents([.fraction(0.9)])
//        }
        .cornerRadius(12)
    }
}

struct SpaceCard_Previews: PreviewProvider {
    static var previews: some View {
        SpaceCard(space: .preview)
    }
}
