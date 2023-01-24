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
     .remote(url: "https://github.com/100mslive/100ms-ios-sdk.git",requirement: .upToNextMinor(from: "0.6.2")),
    ],
    productTypes: ["StreamChatSwiftUI" : .framework, "StreamChat": .framework, "HMSSDK": .framework]
)

let dependencies = Dependencies(
    swiftPackageManager: swiftPackageManagerDependencies,
    platforms: [.iOS]
)
