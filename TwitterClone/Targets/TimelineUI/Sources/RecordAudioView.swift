//
//  RecordAudioView.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 28.1.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI

struct RecordAudioView: View {
    @State private var isCanceled = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                MyProfileImage(action: {
                    
                })
                    .scaleEffect(2)

                Spacer()

                Text("What's happening?")
                Text("Hit rocord")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

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
                        .foregroundColor(.white)
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

struct RecordAudioView_Previews: PreviewProvider {
    static var previews: some View {
        RecordAudioView()
    }
}
