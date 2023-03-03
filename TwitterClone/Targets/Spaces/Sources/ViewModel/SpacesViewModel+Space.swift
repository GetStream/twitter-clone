//
//  SpacesViewModel+Space.swift
//  Spaces
//
//  Created by Stefan Blos on 01.03.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import StreamChat

extension SpacesViewModel {
    
    @MainActor
    func joinSpace(id: String) async {
        do {
            let channelId = try ChannelId(cid: "livestream:\(id)")
            
            // add user to the channel members
            let controller = chatClient.channelController(for: channelId)
            if let currentUserId = chatClient.currentUserId {
                controller.addMembers(userIds: [currentUserId])
            }
            
            await joinCall(with: id, in: channelId)
            
            isInSpace = true
        } catch {
            setInfoMessage(text: error.localizedDescription, type: .error)
            print(error.localizedDescription)
            isInSpace = false
        }
    }
    
    @MainActor
    func leaveSpace(id: String) {
        if let channelId = try? ChannelId(cid: "livestream:\(id)") {
            let controller = chatClient.channelController(for: channelId)
            
            if let currentUserId = chatClient.currentUserId {
                controller.removeMembers(userIds: [currentUserId])
            }
        }
        
//        leaveCall(with: id)
        isInSpace = false
    }
    
    @MainActor
    func startSpace(id: String) async {
        do {
            let channelId = try ChannelId(cid: "livestream:\(id)")
            
            let callId = await startCall(with: id, in: channelId)
            
            updateChannel(with: channelId, to: .running, callId: callId)
            isInSpace = true
        } catch {
            setInfoMessage(text: error.localizedDescription, type: .error)
            print(error.localizedDescription)
            isInSpace = false
        }
    }
    
    @MainActor
    func endSpace(with id: String) {
        if let channelId = try? ChannelId(cid: "livestream:\(id)") {
            // TODO: This will need to be .finished, only for debugging purposes.
            updateChannel(with: channelId, to: .planned)
        }
        // TODO: stop observing channel updates
        // TODO: should we lock the room?
        // TODO: deactivate to focus on channel updates for now
//        endCall()
    }
    
}
