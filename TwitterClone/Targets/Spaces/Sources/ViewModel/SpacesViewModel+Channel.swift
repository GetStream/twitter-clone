//
//  SpacesViewModel+Channel.swift
//  Spaces
//
//  Created by Stefan Blos on 16.02.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamChat

extension SpacesViewModel {
    
    func watchChannel(id: String) {
        let channelId = ChannelId(type: .livestream, id: id)
        
        self.channelWatcher = chatClient.channelController(for: channelId)
        
        channelWatcher?.synchronize({ [weak self] error in
            if let error = error {
                print("Error trying to watch channel: \(error.localizedDescription)")
            }
            
            if let channel = self?.channelWatcher?.channel {
                let updatedSpace = Space.from(channel)
                self?.selectedSpace?.speakers = updatedSpace.speakers
                self?.selectedSpace?.listeners = updatedSpace.listeners
            }
        })
    }
    
    func updateChannel(with id: ChannelId, to state: SpaceState) {
        if let selectedSpace {
            var spaceExtraData = selectedSpace.createExtraData()
            spaceExtraData["spaceState"] = .string(state.rawValue)
            let channelController = chatClient.channelController(for: id)
            channelController.updateChannel(
                name: selectedSpace.name,
                imageURL: nil,
                team: nil,
                extraData: spaceExtraData
            )
        } else {
            print("No selected space.")
        }
    }
    
}
