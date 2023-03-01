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
        /// We initialize the call with the given `id` as the name and connect it to the `channelId`.
        /// In error case, we return `nil` here and show an error message.
        guard let call = try? await chatClient.createCall(with: id, in: channelId) else {
            setInfoMessage(text: "Couldn't start call with id '\(id)' in channel '\(channelId.id)'.", type: .error)
            return nil
        }
        
        if let userName = chatClient.currentUserController().currentUser?.name, let userId = chatClient.currentUserController().currentUser?.id {
            /// We take the `userName` and the `userId` to create a config for the `hmsSDK` and join the call.
            /// We set the `userId` as the `metadata` of the channel, in order to later connect the users from the
            /// call data with the users we have in the channel (useful for raising hands, showing who's currently speaking, etc.)
            /// The fact that we join audio-only is handled in the 100ms dashboard.
            let config = HMSConfig(
                userName: userName,
                authToken: call.token,
                metadata: userId
            )
            hmsSDK.join(config: config, delegate: self)
            
            /// If everything worked, we return the `roomId` to save it to the channelData
            return call.call.hms?.roomId
        } else {
            setInfoMessage(text: "Couldn't get user name and ID", type: .error)
            return nil
        }
    }
    
    func joinCall(with id: String, in channelId: ChannelId) async {
        /// We initialize a call. Even though it says `createCall`, due to us using the same `id` and `channelId` the backend
        /// will know that a call exists and only create a new token to join the existing call.
        guard let call = try? await chatClient.createCall(with: id, in: channelId) else {
            setInfoMessage(text: "Couldn't join call with id '\(id)' in channel '\(channelId.id)'.", type: .error)
            return
        }
        
        if let userName = chatClient.currentUserController().currentUser?.name, let userId = chatClient.currentUserController().currentUser?.id {
            /// We create a config, to have `username`, `token`,  and `metadata` set. The metadata contains the `userId` from chat.
            /// By using the chat `userId` in the metadata we can connect users we have in the HMSSDK to the ones from our database.
            let config = HMSConfig(
                userName: userName,
                authToken: call.token,
                metadata: userId
            )
            
            /// Joining the call with the created config.
            hmsSDK.join(config: config, delegate: self)
        } else {
            setInfoMessage(text: "Couldn't get user name and ID", type: .error)
        }
    }
    
    func leaveCall(with id: String) {
        /// When leaving a call we simply call the `.leave` function and reset the tracks that we
        /// have saved for each of the peers in the call.
        hmsSDK.leave { [weak self] _, error in
            if let error {
                print(error.localizedDescription)
                self?.isInSpace = false
            }
            
            self?.ownTrack = nil
            self?.otherTracks = []
            
            /// In the end we update the state.
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
            
            /// Reset track data of self and other peers.
            self?.ownTrack = nil
            self?.otherTracks = []
            
            /// Update the state in the end.
            self?.isInSpace = false
        }
    }
    
}
