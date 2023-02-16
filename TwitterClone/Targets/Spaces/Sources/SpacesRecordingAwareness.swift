//
//  SpacesRecordingAwareness.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 9.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct SpacesRecordingAwareness: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Image("spacesImg")
                .scaleEffect(0.7)
                .hueRotation(.degrees(220))
                .padding(EdgeInsets(top: -64, leading: 0, bottom: -48, trailing: 0))
            
            Text("Recorded Spaces")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            Text("Let the Space live on")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    Image(systemName: "record.circle")
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [.spacesBlue, .spacesViolet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                    VStack(alignment: .leading) {
                        Text("Only speakers are recorded")
                            .font(.headline)
                        Text("Guests who speak will be recorded. The recording is public")
                    }
                }
                
                HStack(alignment: .top) {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [.spacesBlue, .spacesViolet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                    VStack(alignment: .leading) {
                        Text("Replay or share with anyone")
                            .font(.headline)
                        Text("You can listen to the recording at any time. You can also share and retweet it.")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                        Text("Blue")
                    }
                    .foregroundColor(.streamBlue)
                    
                }
            }
            
            Button {
                //
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(width: 240, height: 48)
                        .cornerRadius(24)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [.spacesBlue, .spacesViolet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                    Text("Got it")
                        .foregroundColor(.white)
                }
                .padding()
            }
        }
        .padding()
    }
}

struct SpacesRecordingAwareness_Previews: PreviewProvider {
    static var previews: some View {
        SpacesRecordingAwareness()
    }
}
