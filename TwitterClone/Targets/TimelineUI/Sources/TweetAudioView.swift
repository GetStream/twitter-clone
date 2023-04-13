//
//  TweetAudioView.swift
//  TwitterCloneUI
//
//  Created by amos.gyamfi@getstream.io on 6.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI
import AVFoundation

var audioPlayer: AVAudioPlayer?
func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("ERROR")
        }
    }
}

public struct TweetAudioView: View {
    @State private var isTweetingAudio = "What are some of the well designed iOS apps you know about?"
    public init() {}

    public var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    ProfileImage(imageUrl: "https://picsum.photos/id/429/200/200", action: {})
                        .scaleEffect(0.8)
                    TextField("", text: $isTweetingAudio, axis: .vertical)
                }
                
                Button {
                    playSound(sound: "messageBubble", type: "mp3")
                } label: {
                    ZStack(alignment: .topTrailing) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.streamBlue.opacity(0.25))
                                .frame(width: 250, height: 150)
                            
                            Image(systemName: "play.circle.fill")
                                .font(.largeTitle)
                                .symbolRenderingMode(.hierarchical)
                        }
                       
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.hierarchical)
                            .padding(8)
                    }
                }
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("Tweet")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button {
                            print("tap to initiate a new Space")
                        } label: {
                            Image(systemName: "mic.badge.plus")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }

                        Button {
                            //self.isRecording.toggle()
                        } label: {
                            Image(systemName: "waveform")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        //.fullScreenCover(isPresented: $isRecording, content: RecordAudioView.init)

                        Button {
                            print("tap to record audio")
                        } label: {
                            Image(systemName: "bolt.square")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }

                        Spacer()
                    }
                }
            }
        }
    }
}

struct TweetAudioView_Previews: PreviewProvider {
    static var previews: some View {
        TweetAudioView()
    }
}
