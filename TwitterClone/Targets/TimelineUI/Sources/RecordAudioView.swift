//
//  RecordAudioView.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 28.1.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI

public struct RecordAudioView: View {
    @State private var isCanceled = false
    @State private var isRecording = false
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                MyProfileImage()
                    .scaleEffect(2)
                
                Spacer()
                
                Text("What's happening?")
                Text("Hit rocord")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button {
                    // print("Tap to record")
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.streamBlue.opacity(0.5))
                        Circle()
                            .frame(width: 72, height: 72)
                            .foregroundColor(.streamBlue)
                            .scaleEffect(isRecording ? 1.3 : 1)
                            .animation(.easeInOut(duration: 0.25).repeatForever(autoreverses: true), value: isRecording)
                        Circle()
                            .stroke(lineWidth: 2)
                            .frame(width: 72, height: 72)
                            .foregroundColor(.white)
                            .scaleEffect(isRecording ? 1 : 1.2)
                            .animation(.easeOut(duration: 0.3).repeatForever(autoreverses: true), value: isRecording)
                        Image(systemName: "mic.fill")
                            .foregroundColor(.white)
                    }
                }
                .onAppear {
                    isRecording.toggle()
                }
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        self.isCanceled.toggle()
                    }
                    .fullScreenCover(isPresented: $isCanceled, content: AddNewTweetView.init)
                }
            }
        }
        
    }
}

//struct RecordAudioView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordAudioView()
//    }
//}
