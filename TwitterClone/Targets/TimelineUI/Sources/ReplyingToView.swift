//
//  ReplyingToView.swift
//  TimelineUI
//
//  Created by amos.gyamfi@getstream.io on 15.3.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct ReplyingToView: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image("amos")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Amos")
                                    .font(.subheadline)
                                    .bold()
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.caption)
                                    .foregroundColor(.streamBlue)
                            }
                            Text("@amos_gyamfi")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Replying to")
                            .font(.subheadline)
                            .bold()
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            
                        } label: {
                            Text("Done")
                                .font(.subheadline)
                                .bold()
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

struct ReplyingToView_Previews: PreviewProvider {
    static var previews: some View {
        ReplyingToView()
            .preferredColorScheme(.dark)
    }
}
