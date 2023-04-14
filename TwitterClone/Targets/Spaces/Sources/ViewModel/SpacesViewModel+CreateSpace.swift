//
//  SpacesViewModel+CreateSpace.swift
//  Spaces
//
//  Created by Stefan Blos on 01.03.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamChat

extension SpacesViewModel {
    
    func createChannelForSpace(title: String, description: String, happeningNow: Bool, date: Date) {
        // create new channel
        guard let userId = chatClient.currentUserId else {
            setInfoMessage(text: "Chat client doesn't have a userId", type: .error)
            return
        }
        
        guard let channelController = try? chatClient.channelController(
            createChannelWithId: ChannelId(type: .livestream, id: UUID().uuidString),
            name: title,
            members: [userId],
            isCurrentUserMember: true,
            messageOrdering: .bottomToTop,
            // Potantially invite other users who could be part of it
            invites: [],
            extraData: [
                "spaceChannel": .bool(true),
                "description": .string(description),
                "spaceState": .string(happeningNow ? SpaceState.running.rawValue : SpaceState.planned.rawValue),
                "startTime": .string(date.ISO8601Format()),
                "speakerIdList": .array([.string(String(userId))])
            ]
        ) else {
            setInfoMessage(text: "Channel creation failed", type: .error)
            return
        }
        
        // We should probably do more proper error handling here. At least we're showing the error, which is a start.
        channelController.synchronize { [weak self] error in
            if let error {
                self?.setInfoMessage(text: "Synchronize error: \(error.localizedDescription)", type: .error)
            }
        }
    }
}
