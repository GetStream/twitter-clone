//
//  PopoverView.swift
//  TwitterCloneUI
//
//  Created by Andrew Erickson on 2023-04-13.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct PopoverView<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode

    private let title: String
    private let content: Content

    public init(title: String, content: () -> Content) {
        self.title = title
        self.content = content()
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(
                            action: {
                                presentationMode.wrappedValue.dismiss()
                            },
                            label: {
                                Image(systemName: "xmark")
                            }
                        )
                    }

                    ToolbarItem(placement: .principal) {
                        TTwinLogo()
                    }
                }
        }
    }
}
