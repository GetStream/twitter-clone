//
//  AsyncButton.swift
//  TwitterCloneUI
//
//  Created by Jeroen Leenarts on 23/01/2023.
//  Copyright © 2023 Stream.io Inc.  All rights reserved.
//

import Foundation
import SwiftUI

public struct AsyncButton<Label: View>: View {
    public var action: () async throws -> Void
    public var actionOptions = Set(ActionOption.allCases)
    @ViewBuilder var label: () -> Label

    @State private var isDisabled = false
    @State private var showProgressView = false

    public var body: some View {
        Button(
            action: {
                if actionOptions.contains(.disableButton) {
                    isDisabled = true
                }

                Task {
                    var progressViewTask: Task<Void, Error>?

                    if actionOptions.contains(.showProgressView) {
                        progressViewTask = Task {
                            try await Task.sleep(nanoseconds: 150_000_000)
                            showProgressView = true
                        }
                    }

                    try await action()
                    progressViewTask?.cancel()

                    isDisabled = false
                    showProgressView = false
                }
            },
            label: {
                ZStack {
                    label().opacity(showProgressView ? 0 : 1)

                    if showProgressView {
                        ProgressView()
                    }
                }
            }
        )
        .disabled(isDisabled)
    }
}

public extension AsyncButton {
    enum ActionOption: CaseIterable {
        case disableButton
        case showProgressView
    }
}

public extension AsyncButton where Label == Text {
    init(_ label: String,
         actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
         action: @escaping () async throws -> Void) {
        self.init(action: action) {
            Text(label)
        }
    }
}

public extension AsyncButton where Label == Image {
    init(image name: String,
         bundle: Bundle? = nil,
         actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
         action: @escaping () async throws -> Void) {
        self.init(action: action) {
            Image(name, bundle: bundle)
        }
    }
}
