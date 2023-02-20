//
//  SpacesAddCommentView.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 16.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct SpacesAddCommentView: View {
    public init() {}
    @State private var isShowingCommentArea = ""
    @FocusState private var commentFieldIsFocused: Bool
    
    public var body: some View {
        NavigationStack {
            VStack {
                Text("Today")
                    .bold()
                    .padding(.bottom)
                Text("Did you know?")
                    .font(.caption)
                    .padding(.top)
                
                Text("You can add a reaction by double-clicking any message")
                    .multilineTextAlignment(.center)
                    .font(.caption2)
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Image("spacesLogo")
                            .padding(.top, 48)
                           
                        HStack {
                            Text("Spaces")
                                .font(.subheadline)
                                .bold()
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption2)
                                .foregroundColor(.streamBlue)
                        }
                    }
                }
                
                // Add implementation here
                ToolbarItemGroup(placement: .keyboard) {
                    Button {
                        // Open phot library
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                    }
                    
                    Button {
                        commentFieldIsFocused = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                    
                    TextField("What's happening?", text: $isShowingCommentArea, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(2, reservesSpace: true)
                        .font(.caption)
                        .frame(width: 260)
                        .focused($commentFieldIsFocused)
                    
                    Button {
                        // Send comment
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
                
                // NOTE: Only for presentation only.
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        // Open phot library
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                    }
                    
                    TextField("What's happening?", text: $isShowingCommentArea, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(2, reservesSpace: true)
                        .font(.caption)
                        .frame(width: 260)
                        .keyboardType(.twitter)
                    
                    Button {
                        // Send comment
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
            }
        }
    }
}

struct SpacesAddCommentView_Previews: PreviewProvider {
    static var previews: some View {
        SpacesAddCommentView()
    }
}
