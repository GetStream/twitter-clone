//
//  FeedUser.swift
//  TwitterCloneFeeds
//
//  Created by Jeroen Leenarts on 19/01/2023.
//  Copyright © 2023 Stream.io Inc.  All rights reserved.
//

import Foundation

public struct FeedUser: Refable, Codable {
    let userId: String
    let firstname: String
    let lastname: String
    let username: String
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case created_at
        case updated_at
        case data
        case firstname
        case lastname
        case username
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.createdAt = try container.decode(Date.self, forKey: .created_at)
        self.updatedAt = try container.decode(Date.self, forKey: .updated_at)
        
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        self.firstname = try dataContainer.decode(String.self, forKey: .firstname)
        self.lastname = try dataContainer.decode(String.self, forKey: .lastname)
        self.username = try dataContainer.decode(String.self, forKey: .username)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)

        var dataContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try dataContainer.encode(firstname, forKey: .firstname)
        try dataContainer.encode(lastname, forKey: .lastname)
        try dataContainer.encode(username, forKey: .username)   
    }
    
    func ref() -> String {
        return "SU:" + userId
    }
}
