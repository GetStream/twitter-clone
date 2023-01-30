//
//  File.swift
//  TwitterCloneFeeds
//
//  Created by Jeroen Leenarts on 19/01/2023.
//  Copyright © 2023 Stream.io Inc.  All rights reserved.
//

import Foundation

protocol Refable {
    func ref() -> String
}

// swiftlint:disable identifier_name
enum ActorType: String {
    /// Stream activity
    case SA
    /// Stream reaction
    case SR
    /// Stream object for a collection
    case SO
    /// Stream User
    case SU
}
// swiftlint:enable identifier_name
struct FeedActor: Refable, Encodable {

    var type: ActorType
    var id: String

    func ref() -> String {
        return type.rawValue + id
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(ref())
    }

}
