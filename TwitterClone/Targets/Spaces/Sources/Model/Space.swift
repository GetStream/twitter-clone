//
//  Space.swift
//  Spaces
//
//  Created by Stefan Blos on 16.02.23.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamChat

struct Space: Identifiable {
    let id: String
    let name: String
    let description: String
    let state: SpaceState
    let startDate: Date
    let host: String
    var listeners: [String] = []
    var speakers: [String] = []
}

extension Space {
    
    static func from(_ chatChannel: ChatChannel) -> Space {
        let id = chatChannel.id
        let name = chatChannel.name ?? "Unknown"
        let description = chatChannel.extraData["description"]?.stringValue ?? "Unknown"
        let stateString = chatChannel.extraData["spaceState"]?.stringValue ?? ""
        let state = SpaceState(rawValue: stateString) ?? .planned
        let dateString = chatChannel.extraData["startTime"]?.stringValue ?? Date().ISO8601Format()
        let date = ISO8601DateFormatter().date(from: dateString) ?? Date()
        let host = chatChannel.extraData["hostName"]?.stringValue ?? "Unknown"
        
        return Space(id: id, name: name, description: description, state: state, startDate: date, host: host)
    }
    
}

extension Space {
    
    static var preview: Space = Space(
        id: "testid",
        name: "Test Space",
        description: "This is a preview description for a space.",
        state: .planned,
        startDate: Date(),
        host: "Stefan"
    )
    
}
