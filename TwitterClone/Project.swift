import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project
public let projectVersionNumber = "0.1.0"

let networkKitName = "NetworkKit"
let uiName = "TwitterCloneUI"
let authName = "Auth"
let authUiName = "AuthUI"
let keychainName = "Keychain"

let messagesName = "DirectMessages"
let profileName = "Profile"
let searchName = "Search"
let settingsName = "UserSettings"
let spacesName = "Spaces"
let timelineUiName = "TimelineUI"
let homeUiName = "HomeUI"
let feedsName = "Feeds"
let chatName = "Chat"

let destinations: Destinations = [.iPhone, .iPad, .macWithiPadDesign]

let messagesTarget =
Project.makeFrameworkTargets(name: messagesName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies:
                                    [
                                        .external(name: "StreamChatSwiftUI"),
                                        .external(name: "StreamChat"),
                                        .target(name: authName),
                                        .target(name: feedsName),
                                        .target(name: chatName),
                                        .target(name: uiName)
                                    ])
let chatTarget =
    Project.makeFrameworkTargets(name: chatName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies:
                                    [
                                        .external(name: "StreamChatSwiftUI"),
                                        .external(name: "StreamChat"),
                                        .target(name: authName),
                                        .target(name: feedsName),
                                        .target(name: uiName)
                                    ])

let profileTarget =
    Project.makeFrameworkTargets(name: profileName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: authName),
                                    .target(name: authUiName),
                                    .target(name: messagesName),
                                    .target(name: uiName),
                                    .external(name: "RevenueCat")
                                 ])
let searchTarget =
    Project.makeFrameworkTargets(name: searchName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: feedsName),
                                    .target(name: authName),
                                    .external(name: "InstantSearchSwiftUI"),
                                    .external(name: "InstantSearchInsights"),
                                 ])
let settingsTarget =
    Project.makeFrameworkTargets(name: settingsName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies: [
                                        .target(name: uiName)
                                 ])
let homeUiTarget =
    Project.makeFrameworkTargets(name: homeUiName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: authName),
                                    .target(name: feedsName),
                                    .target(name: searchName),
                                    .target(name: profileName),
                                    .target(name: timelineUiName),
                                    .target(name: messagesName),
                                    .target(name: spacesName),
                                    .target(name: chatName),
                                    .target(name: uiName)
                                 ])

let timelineUiTarget =
    Project.makeFrameworkTargets(name: timelineUiName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: authName),
                                    .target(name: feedsName),
                                    .target(name: searchName),
                                    .target(name: profileName),
                                    .target(name: uiName),
                                    .external(name: "MuxUploadSDK")
                                 ], noResources: false)
let spacesTarget =
    Project.makeFrameworkTargets(name: spacesName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies: [
                                    .external(name: "StreamChatSwiftUI"),
                                    .external(name: "StreamChat"),
                                    .target(name: uiName),
                                    .target(name: authName),
                                    .target(name: chatName),
                                    .external(name: "HMSSDK")
                                 ])
let feedsTarget =
    Project.makeFrameworkTargets(name: feedsName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: uiName),
                                    .target(name: authName),
                                    .target(name: networkKitName)
                                 ])
let networkKitTarget =
    Project.makeFrameworkTargets(name: networkKitName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies: [])
let uiTarget =
    Project.makeFrameworkTargets(name: uiName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies: [], noResources: false)

let authUiTarget =
    Project.makeFrameworkTargets(name: authUiName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: authName),
                                    .target(name: feedsName),
                                    .target(name: uiName)])

let authorizationTarget =
    Project.makeFrameworkTargets(name: authName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: keychainName),
                                    .target(name: networkKitName) ])
let keychainHelperTarget =
    Project.makeFrameworkTargets(name: keychainName, destinations: destinations,
                                 platform: .iOS,
                                 dependencies: [])


// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "TwitterClone",
                          destinations: destinations,
                          versionNumber: projectVersionNumber,
                          platform: .iOS,
                          packages: [],
                          dependencies: [
//                            .external(name: "StreamChatSwiftUI"),
//                            .external(name: "HMSSDK")
                          ],
                          additionalTargets:
                            uiTarget +
                            authUiTarget +
                            authorizationTarget +
                            keychainHelperTarget +
                            messagesTarget +
                            profileTarget +
                            searchTarget +
                            settingsTarget +
                            homeUiTarget +
                            timelineUiTarget +
                            spacesTarget +
                            chatTarget +
                            feedsTarget +
                            networkKitTarget,
                          additionalFiles: ["graph.png", "../README.md", "TwitterCloneStoreKitTesting.storekit"])
