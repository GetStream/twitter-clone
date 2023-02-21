//
//  SpacesViewModel+Call.swift
//  TwitterClone
//
//  Created by Stefan Blos on 17.02.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamChat
import HMSSDK

extension SpacesViewModel {
    
    func startCall(with id: String, in channelId: ChannelId) async -> String? {
        guard let call = try? await chatClient.createCall(with: id, in: channelId) else {
            // TODO: proper error handling
            print("Couldn't start call with id '\(id)' in channel '\(channelId.id)'.")
            return nil
        }
        let token = call.token
        
        // The fact that we join audio-only is handled in the 100ms dashboard
        let config = HMSConfig(userName: chatClient.currentUserController().currentUser?.name ?? "Unknown", authToken: token)
        hmsSDK.join(config: config, delegate: self)
        return call.call.hms?.roomId
    }
    
    func joinCall(with id: String, in channelId: ChannelId) async {
        guard let call = try? await chatClient.createCall(with: id, in: channelId) else {
            // TODO: proper error handling
            print("Couldn't join call with id '\(id)' in channel '\(channelId.id)'.")
            return
        }
        let token = call.token
        
        // TODO: how to join audio only
        let config = HMSConfig(userName: chatClient.currentUserController().currentUser?.name ?? "Unknown", authToken: token)
        
        hmsSDK.join(config: config, delegate: self)
    }
    
    func leaveCall(with id: String) {
        hmsSDK.leave { [weak self] success, error in
            if let error {
                print(error.localizedDescription)
                self?.isInSpace = false
            }
            
            self?.ownTrack = nil
            self?.otherTracks = []
            self?.isInSpace = false
        }
    }
    
    func endCall() {
        // Do we need to lock the room?
        hmsSDK.endRoom(lock: false, reason: "Host ended the room") { [weak self] success, error in
            if let error {
                print("Error ending the space: \(error.localizedDescription)")
            }
            self?.isInSpace = false
        }
    }
    
}
