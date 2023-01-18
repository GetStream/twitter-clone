//
//  Dependencies.swift
//  Config
//
//  Created by Jeroen Leenarts on 12/01/2023.
//

import ProjectDescription

var swiftPackageManagerDependencies = SwiftPackageManagerDependencies(
    [.remote(url: "https://github.com/GetStream/stream-chat-swiftui.git", requirement: .upToNextMajor(from: "4.0.0")),
     .remote(url: "https://github.com/GetStream/stream-chat-swift.git", requirement: .upToNextMajor(from: "4.0.0")),
    ],
    productTypes: ["StreamChatSwiftUI" : .framework, "StreamChat": .framework]
)

let dependencies = Dependencies(
    swiftPackageManager: swiftPackageManagerDependencies,
    platforms: [.iOS]
)
