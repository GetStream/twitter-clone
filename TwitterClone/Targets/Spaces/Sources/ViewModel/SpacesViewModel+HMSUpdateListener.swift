//
//  SpacesViewModel+HMSUpdateListener.swift
//  Spaces
//
//  Created by Stefan Blos on 14.02.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import HMSSDK

extension SpacesViewModel: HMSUpdateListener {
    public func on(join room: HMSRoom) {
        print("[HMSUpdate] on join room: \(room.roomID ?? "unknown")")
        // Do something here
    }
    
    public func on(room: HMSRoom, update: HMSRoomUpdate) {
        print("[HMSUpdate] on room: \(room.roomID ?? "unknown"), update: \(update.description)")
    }
    
    public func on(removedFromRoom notification: HMSRemovedFromRoomNotification) {
        print("[HMSUpdate] onRemovedFromRoom: \(notification.description), reason: \(notification.reason)")
        
        /// This will be called if the host has ended the room. In this case, we need to clean up and end the space locally.
        /// Cleanup the tracks
        ownTrack = nil
        otherTracks = []
        
        /// In the end we update the state.
        isInSpace = false
        
        /// Show the information that the room has ended, and why, to the user.
        setInfoMessage(text: "You were removed from the space.\n\(notification.reason)", type: .information)
    }
    
    public func on(peer: HMSPeer, update: HMSPeerUpdate) {
        // Do something here
        print("[HMSUpdate] on peer: \(peer.name), update: \(update.description)")
        switch update {
        case .peerJoined:
            /// When we are host and it's not the local peer
            if isHost && !peer.isLocal {
                /// Change the role of the peer to "listener"
                if let listenerRole = hmsSDK.roles.first(where: { role in
                    role.name == "listener"
                }) {
                    hmsSDK.changeRole(for: peer, to: listenerRole, force: true)
                }
            }
        default:
            break
        }
    }
    
    public func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
        print("[HMSUpdate] on track: \(track.trackId), update: \(update.description), peer: \(peer.name)")
        switch update {
        case .trackAdded:
            /// If the track that was added is an audio track, add it to our tracks.
            if let audioTrack = track as? HMSAudioTrack {
                if peer.isLocal {
                    ownTrack = audioTrack
                } else {
                    otherTracks.insert(audioTrack)
                }
            }
        case .trackRemoved:
            /// If the track that was removed is an audio track, remove it from our tracks.
            if let audioTrack = track as? HMSAudioTrack {
                if peer.isLocal {
                    ownTrack = nil
                } else {
                    otherTracks.remove(audioTrack)
                }
            }
        default:
            break
        }
    }
     
    public func on(error: Error) {
        // Do something here
        print("[HMSUpdate] on error: \(error.localizedDescription)")
        
        guard let error = error as? HMSError else { return }
        
        if error.isTerminal {
            leaveCall(with: "")
        }
    }
    
    public func on(message: HMSMessage) {
        print("[HMSUpdate] on message: \(message.message)")
    }
    
    public func on(updated speakers: [HMSSpeaker]) {
        print("[HMSUpdate] on updated speakers: \(speakers.description)")
        // Someone is speaking
        // This can be used to indicate who is speaking and visually show this
        withAnimation {
            speakerIds = Set(speakers
                             /// The metadata is equal to the userId
                .compactMap { $0.peer.metadata })
        }
    }
    
    public func onReconnecting() {
        // Do something here
        print("[HMSUpdate] on reconnecting")
    }
    
    public func onReconnected() {
        // Do something here
        print("[HMSUpdate] on reconnected")
    }
}
