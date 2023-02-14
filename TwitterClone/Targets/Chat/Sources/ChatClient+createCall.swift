//
//  ChatClient+createCall.swift
//  Chat
//
//  Created by Jeroen Leenarts on 14/02/2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import StreamChat

public extension ChatClient {
    func createCall(with id: String, in channelId: ChannelId) async throws -> CallWithToken {
        try await withCheckedThrowingContinuation({ continuation in
            channelController(for: channelId).createCall(id: id, type: "video") { result in
                continuation.resume(with: result)
            }
        })
    }
}
