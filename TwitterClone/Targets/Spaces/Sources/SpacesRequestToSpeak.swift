//
//  SpacesRequestToSpeak.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 9.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct SpacesRequestToSpeak: View {
    public init() {}
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
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
            
            Text("People might be able to listen to this Space after it's over")
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
            Text("The host might save this recording. Your voice could be in a replay. ")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 16) {
                
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
                dismiss()
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
                    Text("Request to speak")
                        .foregroundColor(.white)
                }
                .padding(.top)
            }
            
            Button {
                // Dismiss the sheet
                dismiss()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(lineWidth: 2)
                        .frame(width: 240, height: 48)
                        .cornerRadius(24)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [.spacesBlue, .spacesViolet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                    Text("Cancel")
                }
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}

struct SpacesRequestToSpeak_Previews: PreviewProvider {
    static var previews: some View {
        SpacesRequestToSpeak()
    }
}
