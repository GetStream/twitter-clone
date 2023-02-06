//
//  RetweetViewBottonSheet.swift
//  Timeline
//
//  Created by amos.gyamfi@getstream.io on 6.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct RetweetViewBottonSheet: View {
    @State private var isShowingRetweetSheet = false
    
    public init() {}
    
    public var body: some View {
        Button {
            // Add retweet action
            isShowingRetweetSheet.toggle()
        } label: {
            Label("10", systemImage: "arrow.2.squarepath")
                .foregroundColor(.secondary)
        }
        .sheet(isPresented: $isShowingRetweetSheet) {
            VStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 32) {
                    HStack {
                        Image(systemName: "arrow.2.squarepath")
                        Text("Retweet")
                    }
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("Quote Tweet")
                    }
                }
                Button(role: .cancel) {
                    
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.borderless)
            }
            // Add the presentation detents to the content inside the sheet
            //.presentationDetents([.height(200)])
            .presentationDetents([.fraction(0.25)])
        }
    }
}

struct RetweetViewBottonSheet_Previews: PreviewProvider {
    static var previews: some View {
        RetweetViewBottonSheet()
    }
}
