//
//  PausedRecordingAudioView.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 28.1.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI

public struct PausedRecordingAudioView: View {
    @State private var isCanceled = false
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
                
                HStack {
                    ForEach(0 ..< 20) { rect in
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 3, height: .random(in: 16...32))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                Button {
                    // Add pause action
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.streamBlue.opacity(0.5))
                        Circle()
                            .frame(width: 72, height: 72)
                            .foregroundColor(.streamBlue)
                        Circle()
                            .stroke(lineWidth: 2)
                            .frame(width: 72, height: 72)
                            .foregroundColor(.white)
                        Image(systemName: "mic.fill")
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
                    
                    ToolbarItem(placement: .bottomBar) {
                        Text("Paused")
                            .foregroundColor(.secondary)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            self.isDone.toggle()
                        }
                        .sheet(isPresented: $isDone, content: TweetAudioView.init)
                    }
                }
            }
            
        }
    }
}
//struct PausedRecordingAudioView_Previews: PreviewProvider {
//    static var previews: some View {
//        PausedRecordingAudioView()
//    }
//}
