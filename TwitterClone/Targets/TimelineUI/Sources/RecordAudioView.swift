//
//  RecordAudioView.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 28.1.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI
import Profile

public struct RecordAudioView: View {
    @State private var isCanceled = false
    @State private var isRecording = false
    @State private var isShowingRecordingAlert = false
    @Environment(\.presentationMode) var presentationMode
    var profileInfoViewModel: ProfileInfoViewModel
    
    public init(profileInfoViewModel: ProfileInfoViewModel) {
        self.profileInfoViewModel = profileInfoViewModel
    }
    
    public var body: some View {
        NavigationStack {
            VStack {
                Spacer()
        
                ProfileImage(imageUrl: profileInfoViewModel.feedUser?.profilePicture, action: {})
                    .overlay(Circle().stroke(lineWidth: 2))
                    .scaleEffect(2)
                
                Spacer()
                
                Text("What's happening?")
                Text("Hit record")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button {
                    isShowingRecordingAlert = true
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
                .alert("TwitterClone would like to access your microphone", isPresented: $isShowingRecordingAlert) {
                    Button("Don't Allow", role: .cancel) { }
                    Button("OK") { }
                }
                .onAppear {
                    isRecording.toggle()
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
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
