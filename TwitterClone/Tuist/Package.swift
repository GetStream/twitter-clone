// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
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

#endif

let package = Package(
    name: "TwitterClone",
    dependencies: [
        .package(url: "https://github.com/GetStream/stream-chat-swiftui.git", from: "4.0.0"),
        .package(url: "https://github.com/GetStream/stream-chat-swift.git", from: "4.0.0"),
        .package(url: "https://github.com/100mslive/100ms-ios-sdk.git", from: "0.6.2"),
        .package(url: "https://github.com/RevenueCat/purchases-ios.git", from: "4.0.0"),
        .package(url: "https://github.com/algolia/instantsearch-ios", from: "7.0.0"),
        .package(url: "https://github.com/muxinc/swift-upload-sdk", from: "0.0.0"),
    ]
)
