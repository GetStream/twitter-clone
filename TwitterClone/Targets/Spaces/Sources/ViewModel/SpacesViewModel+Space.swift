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
            let controller = chatClient.channelController(for: channelId)
            
            /// Add the user to the members of the channel.
            if let currentUserId = chatClient.currentUserId {
                controller.addMembers(userIds: [currentUserId])
            }
            
            /// Join the 100ms call with the spaceId in `id` and the `channelId`.
            await joinCall(with: id, in: channelId)
            
            /// If everything worked, updated the state
            isInSpace = true
        } catch {
            setInfoMessage(text: error.localizedDescription, type: .error)
            print(error.localizedDescription)
            isInSpace = false
        }
    }
    
    @MainActor
    func leaveSpace(id: String) {
        do {
            let channelId = try ChannelId(cid: "livestream:\(id)")
            let controller = chatClient.channelController(for: channelId)
            
            /// Remove user from the channel members.
            if let currentUserId = chatClient.currentUserId {
                controller.removeMembers(userIds: [currentUserId])
            }
            
            /// Leave the 100ms call.
            leaveCall(with: id)
            
            /// If everything worked, update the state.
            isInSpace = false
        } catch {
            setInfoMessage(text: error.localizedDescription, type: .error)
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func startSpace(id: String) async {
        do {
            let channelId = try ChannelId(cid: "livestream:\(id)")
            
            /// Start a call with the space id as the name of the room and the `channelId`.
            let callId = await startCall(with: id, in: channelId)
            
            /// Update the channel to have state running and the callId attached to its extraData.
            updateChannel(with: channelId, to: .running, callId: callId)
            
            /// If everything worked, update the state.
            isInSpace = true
            setInfoMessage(text: "Your space has started.", type: .information)
        } catch {
            setInfoMessage(text: error.localizedDescription, type: .error)
            print(error.localizedDescription)
            isInSpace = false
        }
    }
    
    @MainActor
    func endSpace(with id: String) {
        do {
            let channelId = try ChannelId(cid: "livestream:\(id)")
            
            /// This channel will be updated to have the state of `.finished`.
            /// TODO: This will need to be .finished, only for debugging purposes is it currently .planned.
            updateChannel(with: channelId, to: .planned)
            
            /// End the 100ms call.
            endCall()
            
            /// If everything worked, update the state.
            isInSpace = false
        } catch {
            setInfoMessage(text: error.localizedDescription, type: .error)
            print(error.localizedDescription)
        }
    }
    
}
