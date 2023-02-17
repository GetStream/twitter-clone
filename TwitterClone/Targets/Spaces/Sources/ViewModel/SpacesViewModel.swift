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
    
    @Published var ownTrack: HMSAudioTrack?
    @Published var otherTracks: Set<HMSAudioTrack> = []
    
    @Published var isAudioMuted = false
    
    @Published private(set) var isInSpace = false
    
    var hmsSDK = HMSSDK.build()
    
    @Published var spaces: [Space] = []
    @Published var selectedSpace: Space?
    
    var channelWatcher: ChatChannelController?
    
    init() {
        let query = ChannelListQuery(
            filter: .equal(.type, to: .livestream)
        )
        
        let controller = chatClient.channelListController(query: query)
        
        controller.synchronize { error in
            if let error = error {
                // TODO: proper error handling
                print("Error querying channels: \(error.localizedDescription)")
            }
            
            self.spaces = Array(controller.channels)
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
    
    @MainActor
    func joinSpace(id: String) async {
        do {
            // TODO: add user to channel as guest
            let channelId = try ChannelId(cid: id)
            let call = try await chatClient.createCall(with: UUID().uuidString, in: channelId)
            let token = call.token
            
            // TODO: how to join audio only
            let config = HMSConfig(userName: chatClient.currentUserController().currentUser?.name ?? "Unknown", authToken: token)
            
            hmsSDK.join(config: config, delegate: self)
            isInSpace = true
            watchChannel(id: id)
        } catch {
            print(error.localizedDescription)
            isInSpace = false
        }
    }
    
    @MainActor
    func startSpace(id: String) async {
        do {
            let channelId = try ChannelId(cid: "livestream:\(id)")
//            let call = try await chatClient.createCall(with: id, in: channelId)
//            let token = call.token
            
            updateChannel(with: channelId, to: .running)
            
            // TODO: how to join audio only
            // TODO: deactivate to focus on channel updates
//            let config = HMSConfig(userName: chatClient.currentUserController().currentUser?.name ?? "Unknown", authToken: token)
//            hmsSDK.join(config: config, delegate: self)
            self.selectedSpace?.state = .running
            isInSpace = true
            watchChannel(id: id)
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
        // TODO: add completion handler
        channelWatcher?.stopWatching()
        // TODO: should we lock the room?
        // TODO: deactivate to focus on channel updates for now
        self.selectedSpace?.state = .planned
        self.isInSpace = false
//        hmsSDK.endRoom(lock: false, reason: "Host ended the room") { [weak self] success, error in
//            if let error {
//                print("Error ending the space: \(error.localizedDescription)")
//            }
//            self?.isInSpace = false
//        }
    }
    
    func leaveSpace() {
        // TODO: add completion handler
        channelWatcher?.stopWatching()
        hmsSDK.leave { [weak self] success, error in
            guard success, error != nil else {
                self?.ownTrack = nil
                self?.otherTracks = []
                self?.isInSpace = false
                return
            }
            
            if let error {
                print(error.localizedDescription)
                self?.isInSpace = false
            }
        }
    }
    
    func toggleAudioMute() {
        isAudioMuted.toggle()
        hmsSDK.localPeer?.localAudioTrack()?.setMute(isAudioMuted)
    }
    
    // TODO: make this return a Result<> with different error types for the errors and display that to users
    func createSpace(title: String, description: String, happeningNow: Bool, date: Date) {
        // create new channel
        guard let userId = chatClient.currentUserId else {
            print("ERROR: chat client doesn't have a userId")
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
                "startTime": .string(date.ISO8601Format())
            ]
        ) else {
            print("Channel creation failed")
            return
        }
        
        // TODO: listen to errors and act accordingly
        channelController.synchronize { error in
            if let error {
                print("Synchronize error: \(error.localizedDescription)")
            }
        }
    }
}
