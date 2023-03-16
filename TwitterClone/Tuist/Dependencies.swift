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
     .remote(url: "https://github.com/RevenueCat/purchases-ios.git", requirement: .range(from: "4.0.0", to: "5.0.0")),
     .remote(url: "https://github.com/algolia/instantsearch-ios", requirement: .range(from: "7.0.0", to: "8.0.0")),
     .remote(url: "https://github.com/muxinc/swift-upload-sdk", requirement: .upToNextMajor(from: "0.0.0")),
    ],
    productTypes: [
        "StreamChatSwiftUI" : .framework,
        "StreamChat": .framework,
        "Nuke": .framework,
        "NukeUI": .framework,
        "InstantSearchSwiftUI": .framework,
        "InstantSearchCore": .framework,
        "InstantSearchTelemetry": .framework,
        "InstantSearchInsights": .framework,
        "AlgoliaSearchClient": .framework,
        "MuxUploadSDK": .framework,
    ]
)

let dependencies = Dependencies(
    swiftPackageManager: swiftPackageManagerDependencies,
    platforms: [.iOS]
)
