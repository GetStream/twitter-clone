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
        
            setInfoMessage(text: "Couldn't start call with id '\(id)' in channel '\(channelId.id)'.", type: .error)
            return nil
        }
        let token = call.token
        
        // The fact that we join audio-only is handled in the 100ms dashboard
        if let userName = chatClient.currentUserController().currentUser?.name, let userId = chatClient.currentUserController().currentUser?.id {
            let config = HMSConfig(
                userName: userName,
                authToken: token,
                metadata: userId
            )
            hmsSDK.join(config: config, delegate: self)
            return call.call.hms?.roomId
        } else {
            setInfoMessage(text: "Couldn't get user name and ID", type: .error)
            return nil
        }
    }
    
    func joinCall(with id: String, in channelId: ChannelId) async {
        guard let call = try? await chatClient.createCall(with: id, in: channelId) else {
            setInfoMessage(text: "Couldn't join call with id '\(id)' in channel '\(channelId.id)'.", type: .error)
            return
        }
        let token = call.token
        
        // For Metadata:
        // ID and Raise Hand (JSON Encoded)
        if let userName = chatClient.currentUserController().currentUser?.name, let userId = chatClient.currentUserController().currentUser?.id {
            let config = HMSConfig(
                userName: userName,
                authToken: token,
                metadata: userId
            )
            hmsSDK.join(config: config, delegate: self)
        } else {
            setInfoMessage(text: "Couldn't get user name and ID", type: .error)
        }
    }
    
    func leaveCall(with id: String) {
        hmsSDK.leave { [weak self] _, error in
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
        /// Do we need to lock the room?
        /// No, this only makes sure that the room can never be started again. During development, no locking it makes it easier
        /// to debug, and with the finished state making it impossible to restart a room, we should be safe.
        /// --------
        /// Do we need to throw out participants?
        /// No, the call will be ended automatically. We can listen for room events and show them accordingly. Everything else
        /// is handled with the channel properties that we control.
        hmsSDK.endRoom(lock: false, reason: "Host ended the room") { [weak self] _, error in
            if let error {
                self?.setInfoMessage(text: "Error ending the space: \(error.localizedDescription)", type: .error)
            }
            self?.isInSpace = false
        }
    }
    
}
