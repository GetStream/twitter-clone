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
    
    @Published var isInSpace = false
    
    var hmsSDK = HMSSDK.build()
    
    @MainActor
    func joinSpace() async {
        do {
            // TODO: Use real channel Ids
            let channelCid = "messaging:call-test-channel"
            let channelId = try ChannelId(cid: channelCid)
            let call = try await chatClient.createCall(with: UUID().uuidString, in: channelId)
            // TODO: how to get the token? (we could use chatclient)
            let token = call.token
            // TODO: how to get the name correctly
            // TODO: how to join audio only
            let config = HMSConfig(userName: "Stefan", authToken: token)
            
            hmsSDK.join(config: config, delegate: self)
            isInSpace = true
        } catch {
            print(error.localizedDescription)
            isInSpace = false
        }
    }
    
    func leaveSpace() {
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
}
