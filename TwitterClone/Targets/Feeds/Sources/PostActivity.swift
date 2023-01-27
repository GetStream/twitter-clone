//
//  PostActivity.swift
//  TwitterCloneFeeds
//
//  Created by Jeroen Leenarts on 19/01/2023.
//  Copyright © 2023 Stream.io Inc.  All rights reserved.
//

import Foundation

protocol Activity {
    var actor: String { get set }
    /// The verb of the activity.
    var verb: String { get set }
    /// The object of the activity.
    /// - Note: It shouldn't be empty.
    var object: String { get set }
    var id: String { get set }
}

public struct EnrichedPostActivity: Decodable, Identifiable {
    enum CodingKeys: CodingKey {
        case id
        case actor
        case object
        case verb
        case time
        case tweetPhoto
    }
    
    public var actor: FeedUser
    public var verb: String
    public var object: String
    public var id: String
    
    public var tweetPhoto: String?
    
    public var numberOfLikes: String?
    public var numberOfComments: String?

    public var time: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        actor = try container.decode(FeedUser.self, forKey: .actor)
        verb = try container.decode(String.self, forKey: .verb)
        object = try container.decode(String.self, forKey: .object)
        id = try container.decode(String.self, forKey: .id)
        time = try container.decode(String.self, forKey: .time)
        tweetPhoto = try container.decodeIfPresent(String.self, forKey: .tweetPhoto)
    }
}

public struct PostActivity: Activity, Encodable, Decodable, Identifiable {
    enum CodingKeys: CodingKey {
        case id
        case actor
        case object
        case verb
        case tweetPhoto
    }
    public var actor: String
    /// The verb of the activity.
    public var verb: String
    /// The object of the activity.
    /// - Note: It shouldn't be empty.
    public var object: String
    public var id: String
    
    //TODO: needs to come from somewhere:
    public var userName: String?
    public var userHandle: String?
    public var tweetSentAt: String?
    public var tweetSummary: String?
    public var hashTag: String?
    public var tweetPhoto: String?
    public var numberOfLikes: String?
    public var numberOfComments: String?
            
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("SU:" + self.actor, forKey: .actor)
        try container.encode(self.verb, forKey: .verb)
        try container.encode(self.object, forKey: .object)
        if let tweetPhoto {
            try container.encode(tweetPhoto, forKey: .tweetPhoto)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        actor = try container.decode(String.self, forKey: .actor)
        verb = try container.decode(String.self, forKey: .verb)
        object = try container.decode(String.self, forKey: .object)
        id = try container.decode(String.self, forKey: .id)
        
        tweetPhoto = try container.decodeIfPresent(String.self, forKey: .tweetPhoto)
    }
}

public struct PostActivityResponse: Activity, Decodable {
    //{"actor":"SU:6240378a0cb3a15b1ca56a4dfe4a3f07","duration":"5.78ms","foreign_id":"","id":"246eb280-97e5-11ed-831c-069d4b3df3d5","object":"what is this","origin":null,"target":"","time":"2023-01-19T10:36:33.289280","verb":"post"}

    var actor: String
    /// The verb of the activity.
    var verb: String
    var duration: String
    var foreign_id: String
    var id: String
    /// The object of the activity.
    /// - Note: It shouldn't be empty.
    var object: String
    var origin: String
    var target: String
}
