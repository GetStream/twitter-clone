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
    @Published var speakerIds: Set<String> = []
    var hmsSDK = HMSSDK.build()
        
    // Space-related properties
    @Published var spaces: [Space] = []
    @Published var selectedSpace: Space?
    @Published var isInSpace = false
    
    @Published var reconnecting = false
    
    // Info message
    @Published var infoMessage: InfoMessage?
    
    // Channel-related properties
    var eventsController: EventsController?
    
    /// Determines if the current user is the host of the selected space.
    var isHost: Bool {
        guard let userId = chatClient.currentUserId, let hostId = selectedSpace?.hostId else {
            return false
        }
        
        return userId == hostId
    }
    
    var isSpeaker: Bool {
        guard let userId = chatClient.currentUserId, let space = selectedSpace else {
            return false
        }
        
        return space.speakerIdList.contains(userId)
    }
    
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
    
    func spaceCardTapped(space: Space) {
        watchChannel(id: space.id)
        selectedSpace = space
    }
    
    @MainActor
    func spaceCloseTapped() {
        unwatchChannel()
        
        if let selectedSpace {
            if isHost {
                endSpace(with: selectedSpace.id)
            } else {
                leaveSpace(id: selectedSpace.id)
            }
        }
        selectedSpace = nil
    }
    
    @MainActor
    func spaceButtonTapped() {
        guard let spaceId = selectedSpace?.id else {
            setInfoMessage(text: "Couldn't find space currently. Please try again later.", type: .error)
            return
        }
        if isInSpace {
            if isHost {
                endSpace(with: spaceId)
            } else {
                leaveSpace(id: spaceId)
            }
        } else {
            if isHost {
                Task {
                    await startSpace(id: spaceId)
                }
            } else {
                Task {
                    await joinSpace(id: spaceId)
                }
            }
        }
    }
    
    func toggleAudioMute() {
        isAudioMuted.toggle()
        hmsSDK.localPeer?.localAudioTrack()?.setMute(isAudioMuted)
    }
    
}
