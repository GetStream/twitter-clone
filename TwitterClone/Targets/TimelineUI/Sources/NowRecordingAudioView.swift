//
//  NowRecordingAudioView.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 28.1.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI

public struct NowRecordingAudioView: View {
    @State private var isCanceled = false
    @State private var isRecording = false
    @State private var isDone = false
    public init() {}
    
    // Recording
    @State private var counter: Int = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isVisible: Bool = false
    
    public var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                ProfileImage(imageUrl: "https://picsum.photos/id/429/200/200", action: {})
                    .overlay(Circle().stroke(lineWidth: 2))
                    .scaleEffect(2)
                
                Spacer()
                
                SoundIndicatorView()
                
                Spacer()
                
                Button {
                    // Add pause action
                } label: {
                    ZStack {
                        Image(systemName: "pause.circle")
                            .font(.system(size: 64))
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
                    // Show RecordAudioView.init instead of NowRecordingAudioView.init
                    .sheet(isPresented: $isCanceled, content: NowRecordingAudioView.init)
                }
                
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "mic.fill")
                            .fontWeight(.bold)
                            .opacity(isVisible ? 0 : 1)
                            .foregroundColor(Color(.systemRed))
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isVisible)
                            .onAppear {
                                isVisible = true
                            }
                        
                        Text("\(counter)")
                            .onReceive(timer) { _ in
                                counter += 1
                            }
                    }
                    .font(.caption2)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        self.isDone.toggle()
                    }
                    .sheet(isPresented: $isDone, content: PausedRecordingAudioView.init)
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
