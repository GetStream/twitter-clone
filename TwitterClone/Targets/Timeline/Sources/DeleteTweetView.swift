//
//  DeleteTweetView.swift
//  Timeline
//
//  Created by amos.gyamfi@getstream.io on 4.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import TwitterCloneUI

public struct DeleteTweetView: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack {
                Text("Delete Tweet")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            // print("perform tweet destruction here")
                        } label: {
                            Text("Delete Tweet")
                            Image(systemName: "trash")
                        }
                        
                        Button {
                            // print("perform tweet pinning action")
                        } label: {
                            Text("Pin to profile")
                            Image(systemName: "pin")
                        }
                        
                        Button {
                            // print("perform tweet muting action")
                        } label: {
                            Text("Mute this conversation")
                            Image(systemName: "speaker.slash")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color(.systemGray))
                    }
                }
            }
        }
    }
}

struct DeleteTweetView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteTweetView()
    }
}
