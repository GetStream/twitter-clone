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
        // Do something here
        for peer in room.peers {
            if let audioTrack = peer.audioTrack {
                if peer.isLocal {
                    ownTrack = audioTrack
                } else {
                    otherTracks.insert(audioTrack)
                }
            }
        }
    }
    
    public func on(room: HMSRoom, update: HMSRoomUpdate) {
        // Do something here
    }
    
    public func on(peer: HMSPeer, update: HMSPeerUpdate) {
        switch update {
        case .peerJoined:
            if let audioTrack = peer.audioTrack {
                otherTracks.insert(audioTrack)
            }
        case .peerLeft:
            if let audioTrack = peer.audioTrack {
                otherTracks.remove(audioTrack)
            }
        default:
            break
        }
    }
    
    public func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
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
    }
    
    public func on(message: HMSMessage) {
        // Do something here
    }
    
    public func on(updated speakers: [HMSSpeaker]) {
        // Do something here
    }
    
    public func onReconnecting() {
        // Do something here
    }
    
    public func onReconnected() {
        // Do something here
    }
    
    
}
