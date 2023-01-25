//
//  FeedFollowers.swift
//  TwitterCloneFeeds
//
//  Created by Jeroen Leenarts on 20/01/2023.
//  Copyright © 2023 Stream.io Inc.  All rights reserved.
//

import Foundation

public struct FeedFollower: Decodable {
    
    public let feedId: String
    public let targetId: String
    public let createdAt: Date
    public let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case feedId = "feed_id"
        case targetId = "target_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        feedId  = try container.decode(String.self, forKey: .feedId)
        targetId  = try container.decode(String.self, forKey: .targetId)
        createdAt  = try container.decode(Date.self, forKey: .createdAt)
        updatedAt  = try container.decode(Date.self, forKey: .updatedAt)

    }
}

struct FeedFollowers: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    let followers: [FeedFollower]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        followers = try container.decode([FeedFollower].self, forKey: .results)
    }
}


//{"results":[{"feed_id":"timeline:6240378a0cb3a15b1ca56a4dfe4a3f07","target_id":"user:47b2d8af2716fee6303a1a036309d892","created_at":"2023-01-19T15:06:39.173830389Z","updated_at":"2023-01-19T15:06:39.173830389Z"}],"duration":"2.46ms"}
      
