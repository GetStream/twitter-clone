import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

let kitName = "TwitterCloneKit"
let networkKitName = "TwitterCloneNetworkKit"
let uiName = "TwitterCloneUI"
let authName = "TwitterCloneAuth"
let authUiName = "TwitterCloneAuthUI"
let keychainName = "TwitterCloneKeychain"

let messagesName = "TwitterCloneMessages"
let profileName = "TwitterCloneProfile"
let searchName = "TwitterCloneSearch"
let settingsName = "TwitterCloneSettings"
let spacesName = "TwitterCloneSpaces"
let timelineName = "TwitterCloneTimeline"
let feedsName = "TwitterCloneFeeds"

let messagesTarget =
    Project.makeFrameworkTargets(name: messagesName,
                                 platform: .iOS,
                                 dependencies:
                                    [
                                        .target(name: authName)
                                    ])
let profileTarget =
    Project.makeFrameworkTargets(name: profileName,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: authName)
                                 ])
let searchTarget =
    Project.makeFrameworkTargets(name: searchName,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: authName)
                                 ])
let settingsTarget =
    Project.makeFrameworkTargets(name: settingsName,
                                 platform: .iOS,
                                 dependencies: [])
let timelineTarget =
    Project.makeFrameworkTargets(name: timelineName,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: authName),
                                    .target(name: feedsName)
                                 ])
let spacesTarget =
    Project.makeFrameworkTargets(name: spacesName,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: authName),
                                    .external(name: "HMSSDK")
                                 ])
let feedsTarget =
    Project.makeFrameworkTargets(name: feedsName,
                                 platform: .iOS,
                                 dependencies: [
                                    .target(name: authName),
                                    .target(name: networkKitName)
                                 ])
let kitTarget =
    Project.makeFrameworkTargets(name: kitName,
                                 platform: .iOS,
                                 dependencies: [
                                    .external(name: "StreamChat")
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
                          dependencies: [.external(name: "StreamChatSwiftUI")],
                          additionalTargets: kitTarget + uiTarget + authUiTarget + authorizationTarget + keychainHelperTarget + messagesTarget + profileTarget + searchTarget + settingsTarget + timelineTarget + spacesTarget + feedsTarget + networkKitTarget, additionalFiles: ["graph.png", "../README.md"])
