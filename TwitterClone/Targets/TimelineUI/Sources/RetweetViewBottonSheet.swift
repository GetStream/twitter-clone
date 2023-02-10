//
//  RetweetViewBottonSheet.swift

import SwiftUI

public struct RetweetViewBottonSheet: View {
    public init() {}
    @State private var isShowingRetweetSheet = false
    
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
            .preferredColorScheme(.dark)
    }
}
