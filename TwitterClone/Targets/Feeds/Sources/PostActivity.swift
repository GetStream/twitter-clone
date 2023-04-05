//
//  PostActivity.swift
//  TwitterCloneFeeds
//
//  Created by Jeroen Leenarts on 19/01/2023.
//  Copyright © 2023 Stream.io Inc.  All rights reserved.
//

import Foundation

public struct ReactionCounts: Decodable {
    enum CodingKeys: CodingKey {
        case like
        case reply
    }
    
    public var likeCount: Int
    public var replyCount: Int
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        likeCount = try container.decodeIfPresent(Int.self, forKey: .like) ?? 0
        replyCount = try container.decodeIfPresent(Int.self, forKey: .reply) ?? 0

    }
    
    public init(likeCount: Int, replyCount: Int) {
        self.likeCount = likeCount
        self.replyCount = replyCount
    }
}

public struct EnrichedPostActivity: Decodable, Identifiable {
    static let dateComponentsFormatter: DateComponentsFormatter = {
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 2
        form.unitsStyle = .abbreviated
        form.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        return form
    }()

    enum CodingKeys: CodingKey {
        case id
        case actor
        case object
        case verb
        case time
        case tweetPhoto
        case tweetMovieAssetId
        case tweetMoviePlaybackId
        case reaction_counts
    }

    public var actor: FeedUser
    public var verb: String
    public var object: String
    public var id: String

    public var tweetPhoto: String?
    public var tweetMovieAssetId: String?
    public var tweetMoviePlaybackId: String?

    public var time: Date
    
    public var reactionCounts: ReactionCounts

    public var postAge: String {
        return EnrichedPostActivity.dateComponentsFormatter.string(from: time, to: Date()) ?? "-"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        actor = try container.decode(FeedUser.self, forKey: .actor)
        verb = try container.decode(String.self, forKey: .verb)
        object = try container.decode(String.self, forKey: .object)
        id = try container.decode(String.self, forKey: .id)
        time = try container.decode(Date.self, forKey: .time)
        tweetPhoto = try container.decodeIfPresent(String.self, forKey: .tweetPhoto)
        tweetMovieAssetId = try container.decodeIfPresent(String.self, forKey: .tweetMovieAssetId)
        tweetMoviePlaybackId = try container.decodeIfPresent(String.self, forKey: .tweetMoviePlaybackId)

        reactionCounts = try container.decodeIfPresent(ReactionCounts.self, forKey: .reaction_counts) ?? ReactionCounts(likeCount: 0, replyCount: 0)
    }

    public static func previewPostActivities() -> [EnrichedPostActivity] {
        return previewData()
    }

    internal init(actor: FeedUser, verb: String, object: String, id: String, time: Date) {
        self.actor = actor
        self.verb = verb
        self.object = object
        self.id = id
        self.time = time
        self.reactionCounts = ReactionCounts(likeCount: 7, replyCount: 10)
    }
}

public struct PostActivity: Encodable {

    enum CodingKeys: CodingKey {
        case actor
        case object
        case verb
        case tweetPhoto
        case tweetMovieAssetId
        case tweetMoviePlaybackId
    }
    public var actor: String
    /// The verb of the activity.
    public var verb: String = "post"
    /// The object of the activity.
    /// - Note: It shouldn't be empty.
    public var object: String

    public var tweetPhoto: String?
    public var tweetMovieAssetId: String?
    public var tweetMoviePlaybackId: String?

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("SU:" + self.actor, forKey: .actor)
        try container.encode(self.verb, forKey: .verb)
        try container.encode(self.object, forKey: .object)
        if let tweetPhoto {
            try container.encode(tweetPhoto, forKey: .tweetPhoto)
        }
        if let tweetMovieAssetId {
            try container.encode(tweetMovieAssetId, forKey: .tweetMovieAssetId)
        }
        if let tweetMoviePlaybackId {
            try container.encode(tweetMoviePlaybackId, forKey: .tweetMoviePlaybackId)
        }
    }

    public init(actor: String, object: String, tweetPhotoUrlString: String?, tweetMovieAssetId: String?, tweetMoviePlaybackId: String?) {
        self.actor = actor
        self.object = object
        self.tweetPhoto = tweetPhotoUrlString
        self.tweetMovieAssetId = tweetMovieAssetId
        self.tweetMoviePlaybackId = tweetMoviePlaybackId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        actor = try container.decode(String.self, forKey: .actor)
        verb = try container.decode(String.self, forKey: .verb)
        object = try container.decode(String.self, forKey: .object)

        tweetPhoto = try container.decodeIfPresent(String.self, forKey: .tweetPhoto)
        tweetMovieAssetId = try container.decodeIfPresent(String.self, forKey: .tweetMovieAssetId)
    }
}

public struct PostActivityResponse: Decodable {
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

private func previewData() -> [EnrichedPostActivity] {
    let user1 = FeedUser(userId: "preview_user_id",
                         username: "username",
                         firstname: "firstname",
                         lastname: "lastname",
                         createdAt: Date(),
                         updatedAt: Date(),
                         aboutMe: "about me",
                         profilePicture: nil)
    return [
        EnrichedPostActivity(actor: user1,
                             verb: "post",
                             object: "",
                             id: "",
                             time: Date())
    ]

}
