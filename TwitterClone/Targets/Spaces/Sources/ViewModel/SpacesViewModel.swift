//
//  SpacesViewModel.swift
//  Spaces
//
//  Created by Stefan Blos on 14.02.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import HMSSDK
import Chat
import StreamChat
import StreamChatSwiftUI

public class SpacesViewModel: ObservableObject {
    
    @Injected(\.chatClient) var chatClient
    
    // HMS-related properties
    @Published var ownTrack: HMSAudioTrack?
    @Published var otherTracks: Set<HMSAudioTrack> = []
    @Published var isAudioMuted = false
        
    // Space-related properties
    @Published var spaces: [Space] = []
    @Published var selectedSpace: Space?
    @Published var isInSpace = false
    
    // Info message
    @Published var infoMessage: InfoMessage?
    
    var hmsSDK = HMSSDK.build()
    
    var eventsController: EventsController?
    
    init() {
        let query = ChannelListQuery(
            filter: .equal(.type, to: .livestream)
        )
        
        let controller = chatClient.channelListController(query: query)
        
        controller.synchronize { [weak self] error in
            if let error = error {
                self?.setInfoMessage(text: "Error querying channels: \(error.localizedDescription)", type: .error)
            }
            
            self?.spaces = Array(controller.channels)
                .filter({ channel in
                    channel.type == .livestream
                })
                .filter({ channel in
                    channel.extraData.keys.contains("spaceChannel")
                })
                .map { Space.from($0) }
        }
    }
    
    var isHost: Bool {
        guard let userId = chatClient.currentUserId, let hostId = selectedSpace?.hostId else {
            return false
        }
        
        return userId == hostId
    }
    
    func spaceCardTapped(space: Space) {
        watchChannel(id: space.id)
        selectedSpace = space
    }
    
    func spaceCloseTapped() {
        // TODO: unwatch Channel
        selectedSpace = nil
    }
    
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
            print(error.localizedDescription)
            isInSpace = false
        }
    }
    
    func leaveSpace(id: String) {
        // TODO: stop observing channel updates
        
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
            print(error.localizedDescription)
            isInSpace = false
        }
    }
    
    func endSpace(with id: String) {
        if let channelId = try? ChannelId(cid: "livestream:\(id)") {
            // TODO temporary
            updateChannel(with: channelId, to: .planned)
        }
        // TODO: stop observing channel updates
        // TODO: should we lock the room?
        // TODO: deactivate to focus on channel updates for now
//        endCall()
    }
    
    func toggleAudioMute() {
        isAudioMuted.toggle()
        hmsSDK.localPeer?.localAudioTrack()?.setMute(isAudioMuted)
    }
    
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
        
        /// We should probably do more proper error handling here. At least we're showing the error, which is a start.
        channelController.synchronize { [weak self] error in
            if let error {
                self?.setInfoMessage(text: "Synchronize error: \(error.localizedDescription)", type: .error)
            }
        }
    }
}
