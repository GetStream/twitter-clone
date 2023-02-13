//
//  SoundIndicatorView.swift
//  SwiftUICallingKit
//
//  Display this animated view when users disable their video
//

import SwiftUI

public struct SoundIndicatorView: View {
    public init() {}
    @State private var isSounding = false
    
    public var body: some View {
        HStack {
            ForEach(0 ..< 7) { rect in
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 3, height: .random(in: isSounding ? 16...32 : 8...24))
                    .foregroundColor(.white)
                    .animation(.easeInOut(duration: 0.25).delay(Double(rect) * 0.01).repeatForever(autoreverses: true), value: isSounding)
            }
            .onAppear {
                startSoundAnimation()
            }
        }
    }
    
    func startSoundAnimation() {
        isSounding.toggle()
    }
}

struct SoundIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        SoundIndicatorView()
            .preferredColorScheme(.dark)
    }
}
