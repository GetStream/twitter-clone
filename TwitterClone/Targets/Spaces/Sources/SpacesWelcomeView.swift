//
//  SpacesWelcomeView.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 9.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct SpacesWelcomeView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Image("spacesLogo")
                .padding()
            /*Image(systemName: "waveform.and.mic")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [.spacesBlue, .spacesViolet]), startPoint: .top, endPoint: .bottom)
                )
                .padding()
             */
            
            Text("Welcome to TwitterClone Spaces")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            Text("Where live audio conversations happen")
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    Image(systemName: "globe.europe.africa.fill")
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [.spacesBlue, .spacesViolet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                    VStack(alignment: .leading) {
                        Text("These are public spaces")
                            .font(.headline)
                        Text("Anyone can listen to your spaces")
                    }
                }
                
                HStack(alignment: .top) {
                    Image(systemName: "flame")
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [.spacesBlue, .spacesViolet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                    VStack(alignment: .leading) {
                        Text("Ad-free audio")
                            .font(.headline)
                        Text("Experience ad-free audio chat around the globe")
                    }
                }
                
                HStack(alignment: .top) {
                    Image(systemName: "speaker.wave.2")
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [.spacesBlue, .spacesViolet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                    VStack(alignment: .leading) {
                        Text("Listen or request to speak")
                            .font(.headline)
                        Text("Your followers can always see what spaces you are speaking in.")
                    }
                }
                
                HStack(alignment: .top) {
                    Image(systemName: "shield.lefthalf.filled")
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [.spacesBlue, .spacesViolet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                    VStack(alignment: .leading) {
                        Text("Manage Spaces")
                            .font(.headline)
                        Text("Block and report people in spaces")
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

struct SpacesWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        SpacesWelcomeView()
    }
}
