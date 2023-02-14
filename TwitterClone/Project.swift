import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

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

let messagesTarget =
    Project.makeFrameworkTargets(name: messagesName,
                                 platform: .iOS,
                                 dependencies:
                                    [
                                        .target(name: authName),
                                        .target(name: feedsName),
                                        .target(name: chatName),
                                        .target(name: uiName)
                                    ])
let chatTarget =
    Project.makeFrameworkTargets(name: chatName,
                                 platform: .iOS,
                                 dependencies:
                                    [
                                        .external(name: "StreamChatSwiftUI"),
                                        .target(name: authName),
                                        .target(name: feedsName),
                                        .target(name: uiName)
                                    ])

let profileTarget =
    Project.makeFrameworkTargets(name: profileName,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: authName),
                                    .target(name: authUiName),
                                    .target(name: messagesName),
                                    .target(name: uiName),
                                    .external(name: "RevenueCat")
                                 ])
let searchTarget =
    Project.makeFrameworkTargets(name: searchName,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: feedsName),
                                    .target(name: authName)
                                 ])
let settingsTarget =
    Project.makeFrameworkTargets(name: settingsName,
                                 platform: .iOS,
                                 dependencies: [
                                        .target(name: uiName)
                                 ])
let homeUiTarget =
    Project.makeFrameworkTargets(name: homeUiName,
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
    Project.makeFrameworkTargets(name: timelineUiName,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: authName),
                                    .target(name: feedsName),
                                    .target(name: searchName),
                                    .target(name: profileName),
                                    .target(name: uiName)
                                 ])
let spacesTarget =
    Project.makeFrameworkTargets(name: spacesName,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: uiName),
                                    .target(name: authName),
                                    .target(name: chatName),
                                    .external(name: "HMSSDK")
                                 ])
let feedsTarget =
    Project.makeFrameworkTargets(name: feedsName,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: uiName),
                                    .target(name: authName),
                                    .target(name: networkKitName)
                                 ])
let networkKitTarget =
    Project.makeFrameworkTargets(name: networkKitName,
                                 platform: .iOS,
                                 dependencies: [])
let uiTarget =
    Project.makeFrameworkTargets(name: uiName,
                                 platform: .iOS,
                                 dependencies: [])

let authUiTarget =
    Project.makeFrameworkTargets(name: authUiName,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: authName),
                                    .target(name: feedsName),
                                    .target(name: uiName)])

let authorizationTarget =
    Project.makeFrameworkTargets(name: authName,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: keychainName),
                                    .target(name: networkKitName) ])
let keychainHelperTarget =
    Project.makeFrameworkTargets(name: keychainName,
                                 platform: .iOS,
                                 dependencies: [])


// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "TwitterClone",
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
