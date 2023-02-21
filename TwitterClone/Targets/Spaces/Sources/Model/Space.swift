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
    var state: SpaceState
    let startDate: Date
    let host: String
    let hostId: UserId
    var speakerIdList: [String]
    var speakers: [ChatChannelMember] = []
    var listeners: [ChatChannelMember] = []
    var callId: String?
}

extension Space {
    
    static func from(_ chatChannel: ChatChannel) -> Space {
        let id = chatChannel.cid.id
        let name = chatChannel.name ?? "Unknown"
        let description = chatChannel.extraData["description"]?.stringValue ?? "Unknown"
        let stateString = chatChannel.extraData["spaceState"]?.stringValue ?? ""
        let state = SpaceState(rawValue: stateString) ?? .planned
        let dateString = chatChannel.extraData["startTime"]?.stringValue ?? Date().ISO8601Format()
        let date = ISO8601DateFormatter().date(from: dateString) ?? Date()
        let host = chatChannel.createdBy?.name ?? "Unknown"
        let hostId = chatChannel.createdBy?.id ?? UserId()
        let speakerList = chatChannel.extraData["speakerIdList"]?.arrayValue as? [String] ?? [hostId]
        
        let callId = chatChannel.extraData["callId"]?.stringValue
        
        let speakers = chatChannel.lastActiveMembers.filter { speakerList.contains(String($0.id)) }
        let listeners = chatChannel.lastActiveMembers.filter { !speakers.contains($0) }
        
        return Space(id: id, name: name, description: description, state: state, startDate: date, host: host, hostId: hostId, speakerIdList: speakerList, speakers: speakers, listeners: listeners, callId: callId)
    }
    
}

extension Space {
    
    static var preview: Space {
        let userId = UserId()
        return Space(
            id: "testid",
            name: "Test Space",
            description: "This is a preview description for a space.",
            state: .planned,
            startDate: Date(),
            host: "Stefan",
            hostId: userId,
            speakerIdList: [String(userId)]
        )
    }
    
}

extension Space {
    
    func createExtraData() -> [String: RawJSON] {
        return [
            "spaceChannel": .bool(true),
            "description": .string(description),
            "spaceState": .string(state.rawValue),
            "startTime": .string(startDate.ISO8601Format())
        ]
    }
    
}
