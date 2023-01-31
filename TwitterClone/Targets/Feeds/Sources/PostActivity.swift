//
//  PostActivity.swift
//  TwitterCloneFeeds
//
//  Created by Jeroen Leenarts on 19/01/2023.
//  Copyright © 2023 Stream.io Inc.  All rights reserved.
//

import Foundation

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
    }

    public var actor: FeedUser
    public var verb: String
    public var object: String
    public var id: String

    public var tweetPhoto: String?

    public var numberOfLikes: String?
    public var numberOfComments: String?

    public var time: Date

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
    }
}

public struct PostActivity: Encodable {

    enum CodingKeys: CodingKey {
        case actor
        case object
        case verb
        case tweetPhoto
    }
    public var actor: String
    /// The verb of the activity.
    public var verb: String = "post"
    /// The object of the activity.
    /// - Note: It shouldn't be empty.
    public var object: String

    public var tweetPhoto: String?

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("SU:" + self.actor, forKey: .actor)
        try container.encode(self.verb, forKey: .verb)
        try container.encode(self.object, forKey: .object)
        if let tweetPhoto {
            try container.encode(tweetPhoto, forKey: .tweetPhoto)
        }
    }

    public init(actor: String, object: String, tweetPhotoUrlString: String?) {
        self.actor = actor
        self.object = object
        self.tweetPhoto = tweetPhotoUrlString
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        actor = try container.decode(String.self, forKey: .actor)
        verb = try container.decode(String.self, forKey: .verb)
        object = try container.decode(String.self, forKey: .object)

        tweetPhoto = try container.decodeIfPresent(String.self, forKey: .tweetPhoto)
    }
}

public struct PostActivityResponse: Decodable {
    // {"actor":"SU:6240378a0cb3a15b1ca56a4dfe4a3f07","duration":"5.78ms","foreign_id":"","id":"246eb280-97e5-11ed-831c-069d4b3df3d5","object":"what is this","origin":null,"target":"","time":"2023-01-19T10:36:33.289280","verb":"post"}

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
                         updatedAt: Date())
    return [
        EnrichedPostActivity(actor: user1,
                             verb: "post",
                             object: "",
                             id: "",
                             time: Date())
    ]

//        userProfilePhoto: "https://picsum.photos/id/219/200",
//        userName: "Happy Thoughts",
//        userHandle: "@HappyThoughts",
//        tweetSentAt: "2h",
//        actionsMenuIcon: "ellipsis.circle",
//        tweetSummary: "Starting the day with a positive attitude is key to a happy life 🥰",
//        tweetPhoto: "https://picsum.photos/id/220/350/200",
//        numberOfComments: "1",
//        numberOfLikes: "2"),
//
//    ForYouTweetsStructure(
//        userProfilePhoto: "https://picsum.photos/id/25/200",
//        userName: "Book Worm",
//        userHandle: "@bookworm",
//        tweetSentAt: "3h",
//        actionsMenuIcon: "ellipsis.circle",
//        tweetSummary: "Just finished reading the latest bestseller and I am blown away by the author's storytelling skills",
//        tweetPhoto: "https://picsum.photos/id/81/350/200",
//        numberOfComments: "5",
//        numberOfLikes: "10"),
//
//    ForYouTweetsStructure(
//        userProfilePhoto: "https://picsum.photos/id/3/200",
//        userName: "Pet Parent",
//        userHandle: "@petParent",
//        tweetSentAt: "5h",
//        actionsMenuIcon: "ellipsis.circle",
//        tweetSummary: "Spending the afternoon playing with my furry best friend 🐇 🐈",
//        tweetPhoto: "https://picsum.photos/id/120/350/200",
//        numberOfComments: "42",
//        numberOfLikes: "458"),
//
//    ForYouTweetsStructure(
//        userProfilePhoto: "https://picsum.photos/id/4/200",
//        userName: "Foodie Fiesta",
//        userHandle: "@foodie",
//        tweetSentAt: "10h",
//        actionsMenuIcon: "ellipsis.circle",
//        tweetSummary: "Trying out a new Mexican restaurant and loving the flavors 🥗",
//        tweetPhoto: "https://picsum.photos/id/62/350/200",
//        numberOfComments: "1",
//        numberOfLikes: "3"),
//
//    ForYouTweetsStructure(
//        userProfilePhoto: "https://picsum.photos/id/15/200",
//        userName: "Awo Yaa",
//        userHandle: "@awoyaa",
//        tweetSentAt: "15h",
//        actionsMenuIcon: "ellipsis.circle",
//        tweetSummary: "What is $0 in Swift? 👩‍💻",
//        tweetPhoto: "https://picsum.photos/id/18/350/200",
//        numberOfComments: "70",
//        numberOfLikes: "123")
//    ]

}
