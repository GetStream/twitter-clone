//
//  RetweetView.swift

import SwiftUI

public struct RetweetView: View {
    public init() {}
    @State private var isShowingRetweetSheet = false
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        Button {
            // Add retweet action
            isShowingRetweetSheet.toggle()
        } label: {
            Label("10", systemImage: "arrow.2.squarepath")
                .foregroundColor(.secondary)
        }
        .buttonStyle(.borderless)
        .sheet(isPresented: $isShowingRetweetSheet) {
            VStack(spacing: 32) {
                HStack {
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
                    
                    Spacer()
                }
                .padding(.horizontal, 32)
                
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .padding(EdgeInsets(top: 8, leading: 56, bottom: 8, trailing: 56))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke()
                        )
                }
            }
            // Add the presentation detents to the content inside the sheet
            //.presentationDetents([.height(200)])
            .presentationDetents([.fraction(0.25)])
        }
    }
}

struct RetweetView_Previews: PreviewProvider {
    static var previews: some View {
        RetweetView()
            .preferredColorScheme(.dark)
    }
}
