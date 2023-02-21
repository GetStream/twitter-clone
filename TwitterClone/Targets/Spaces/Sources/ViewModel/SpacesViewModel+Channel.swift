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
        self.eventsController = chatClient.channelEventsController(for: channelId)
        eventsController?.delegate = self
    }
    
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
            print("No selected space.")
        }
    }
    
}

extension SpacesViewModel: EventsControllerDelegate {
    
    public func eventsController(_ controller: EventsController, didReceiveEvent event: Event) {
        // TODO switch through event type to see which type of event it was (see ChannelEvent and MemberEvent files in Stream Chat to make listening more fine-grained
        guard let event = event as? ChannelUpdatedEvent else { return }
        
        self.selectedSpace = Space.from(event.channel)
    }
    
}
