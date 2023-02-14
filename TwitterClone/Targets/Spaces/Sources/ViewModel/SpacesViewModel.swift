//
//  SpacesViewModel.swift
//  Spaces
//
//  Created by Stefan Blos on 14.02.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import HMSSDK

public class SpacesViewModel: ObservableObject {
    
    @Published var ownTrack: HMSAudioTrack?
    @Published var otherTracks: Set<HMSAudioTrack> = []
    
    @Published var isAudioMuted = false
    
    @Published var isInSpace = false
    
    var hmsSDK = HMSSDK.build()
    
    func joinSpace() {
        isInSpace = true
        
        // TODO: how to get the token? (we could use chatclient)
        let token = ""
        // TODO: how to get the name correctly
        // TODO: how to join audio only
        let config = HMSConfig(userName: "Stefan", authToken: token)
        
        hmsSDK.join(config: config, delegate: self)
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
