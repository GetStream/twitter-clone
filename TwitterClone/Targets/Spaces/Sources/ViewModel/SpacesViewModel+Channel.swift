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

    func updateChannel(with id: ChannelId, to state: SpaceState, callId: String? = nil) {
        if let selectedSpace {
            var spaceExtraData = selectedSpace.createExtraData()
            spaceExtraData["spaceState"] = .string(state.rawValue)
            
            if let callId {
                spaceExtraData["callId"] = .string(callId)
            }
            
            let channelController = chatClient.channelController(for: id)
            channelController.updateChannel(
                name: selectedSpace.name,
                imageURL: nil,
                team: nil,
                extraData: spaceExtraData
            )
        } else {
            setInfoMessage(text: "No selected space.", type: .information)
        }
    }
    
}

extension SpacesViewModel: EventsControllerDelegate {
    
    public func eventsController(_ controller: EventsController, didReceiveEvent event: Event) {
        // We should be more fine-grained when listening to events here. This is more like a brute-force method.
        // Examples can be found with the `ChannelEvent` and `MemberEvent` in StreamChat.
        guard let event = event as? ChannelUpdatedEvent else { return }
        let updatedSpace = Space.from(event.channel)
        
        spaces = spaces.filter { space in
            space.id != updatedSpace.id
        }
        spaces.insert(updatedSpace)
        
        if selectedSpace?.id == updatedSpace.id {
            self.selectedSpace = updatedSpace
        }
    }
    
}
