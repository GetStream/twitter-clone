//
//  FeedUser.swift
//  TwitterCloneFeeds
//
//  Created by Jeroen Leenarts on 19/01/2023.
//  Copyright © 2023 Stream.io Inc.  All rights reserved.
//

import Foundation

public struct NewFeedUser: Encodable {
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case data
        case firstname
        case lastname
        case username
        case profilePicture
    }

    public let userId: String
    public let firstname: String
    public let lastname: String
    public let username: String
    public let profilePicture: String?

    public init(userId: String, firstname: String, lastname: String, username: String, profilePicture: String?) {
        self.userId = userId
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.profilePicture = profilePicture
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)

        var dataContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try dataContainer.encode(firstname, forKey: .firstname)
        try dataContainer.encode(lastname, forKey: .lastname)
        try dataContainer.encode(username, forKey: .username)
        if let profilePicture {
            try dataContainer.encode(profilePicture, forKey: .profilePicture)
        }
    }
}

public struct FeedUser: Refable, Codable {
    public let userId: String
    public let firstname: String
    public let lastname: String
    public let username: String
    public let createdAt: Date
    public let updatedAt: Date
    public let aboutMe: String
    public let profilePicture: String?

    public var fullname: String {
        return [firstname, lastname].joined(separator: " ") as String
    }

    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case data
        case firstname
        case lastname
        case username
        case aboutMe = "about_me"
        case profilePicture = "profile_picture"
    }

    public static func previewUser() -> FeedUser {
        return FeedUser(userId: "preview_user_id",
                        username: "preview_user",
                        firstname: "Firstname",
                        lastname: "Lastname",
                        createdAt: Date(),
                        updatedAt: Date(),
                        aboutMe: "",
                        profilePicture: nil
        )
    }

    internal init(userId: String, username: String, firstname: String, lastname: String, createdAt: Date, updatedAt: Date, aboutMe: String, profilePicture: String?) {
        self.userId = userId
        self.username = username
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.firstname = firstname
        self.lastname = lastname
        self.aboutMe = aboutMe
        self.profilePicture = profilePicture

    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)

        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        self.firstname = try dataContainer.decodeIfPresent(String.self, forKey: .firstname) ?? ""
        self.lastname = try dataContainer.decodeIfPresent(String.self, forKey: .lastname) ?? ""
        self.username = try dataContainer.decodeIfPresent(String.self, forKey: .username) ?? ""
        self.aboutMe = try dataContainer.decodeIfPresent(String.self, forKey: .aboutMe) ?? ""

        self.profilePicture = try dataContainer.decodeIfPresent(String.self, forKey: .profilePicture)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)

        var dataContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try dataContainer.encode(firstname, forKey: .firstname)
        try dataContainer.encode(lastname, forKey: .lastname)
        try dataContainer.encode(username, forKey: .username)
        if let profilePicture {
            try dataContainer.encode(profilePicture, forKey: .profilePicture)
        }
    }

    func ref() -> String {
        return "SU:" + userId
    }
}
