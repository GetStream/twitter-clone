//
//  DirectMessagesModel.swift
//  DirectMessages
//
//  Created by Jeroen Leenarts on 10/02/2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamChat
import StreamChatSwiftUI
import Auth
import Feeds
import NetworkKit

@MainActor
public class DirectMessagesModel: ObservableObject {
    // This is the `StreamChat` reference we need to add
    internal var streamChat: StreamChat
    
    public init() {
        streamChat = StreamChat(chatClient: self.chatClient)
    }

    // This is the `chatClient`, with config we need to add
    internal var chatClient: ChatClient = {
        //For the tutorial we use a hard coded api key and application group identifier
        var config = ChatClientConfig(apiKey: .init(TwitterCloneNetworkKit.apiKey))
        config.applicationGroupIdentifier = "group.io.getstream.twitterclone.TwitterClone"

        // The resulting config is passed into a new `ChatClient` instance.
        let client = ChatClient(config: config)
        return client
    }()
    
    public func logout() {
        chatClient.logout(completion: {})
    }
    
    // The `connectUser` function we need to add.
    public func connectUser(authUser: AuthUser, feedUser: FeedUser) throws {
        
        // This is a hardcoded token valid on Stream's tutorial environment.
        let token = try Token(rawValue: authUser.chatToken)
        let feedUserProfilePictureUrl = feedUser.profilePicture.flatMap { URL(string: $0) }

        // Call `connectUser` on our SDK to get started.
        chatClient.connectUser(
            userInfo: .init(id: authUser.userId,
                            name: feedUser.fullname,
                            imageURL: feedUserProfilePictureUrl),
                token: token
        ) { error in
            // TODO improve error handling
            if let error {
                // Some very basic error handling only logging the error.
                log.error("connecting the user failed \(error)")
                return
            }
        }
    }
}
