//
//  SpacesViewModel+HMSUpdateListener.swift
//  Spaces
//
//  Created by Stefan Blos on 14.02.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import HMSSDK

extension SpacesViewModel: HMSUpdateListener {
    public func on(join room: HMSRoom) {
        print("[HMSUpdate] on join room: \(room.roomID ?? "unknown")")
        // Do something here
    }
    
    public func on(room: HMSRoom, update: HMSRoomUpdate) {
        print("[HMSUpdate] on room: \(room.roomID ?? "unknown"), update: \(update.description)")
    }
    
    public func on(peer: HMSPeer, update: HMSPeerUpdate) {
        // Do something here
        print("[HMSUpdate] on peer: \(peer.name), update: \(update.description)")
//        switch update {
//        case .peerJoined:
//            if let audioTrack = peer.audioTrack {
//                otherTracks.insert(audioTrack)
//            }
//        case .peerLeft:
//            if let audioTrack = peer.audioTrack {
//                otherTracks.remove(audioTrack)
//            }
//        default:
//            break
//        }
    }
    
    public func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
        print("[HMSUpdate] on track: \(track.trackId), update: \(update.description), peer: \(peer.name)")
        switch update {
        case .trackAdded:
            if let audioTrack = track as? HMSAudioTrack {
                if peer.isLocal {
                    ownTrack = audioTrack
                } else {
                    otherTracks.insert(audioTrack)
                }
            }
        case .trackRemoved:
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
    }
    
    public func on(message: HMSMessage) {
        print("[HMSUpdate] on message: \(message.message)")
    }
    
    public func on(updated speakers: [HMSSpeaker]) {
        // Do something here
        print("[HMSUpdate] on updated speakers: \(speakers.description)")
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
