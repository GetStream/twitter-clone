import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

let kitName = "TwitterCloneKit"
let uiName = "TwitterCloneUI"
let authorizationName = "TwitterCloneAuth"
let keychainName = "TwitterCloneKeychain"

let messagesName = "TwitterCloneMessages"
let profileName = "TwitterCloneProfile"
let searchName = "TwitterCloneSearch"
let settingsName = "TwitterCloneSettings"
let spacesName = "TwitterCloneSpaces"
let timelineName = "TwitterCloneTimeline"

let messagesTarget = Project.makeFrameworkTargets(name: messagesName, platform: .iOS, dependencies: [])
let profileTarget = Project.makeFrameworkTargets(name: profileName, platform: .iOS, dependencies: [])
let searchTarget = Project.makeFrameworkTargets(name: searchName, platform: .iOS, dependencies: [])
let settingsTarget = Project.makeFrameworkTargets(name: settingsName, platform: .iOS, dependencies: [])
let timelineTarget = Project.makeFrameworkTargets(name: timelineName, platform: .iOS, dependencies: [])
let spacesTarget = Project.makeFrameworkTargets(name: spacesName, platform: .iOS, dependencies: [])

let kitTarget = Project.makeFrameworkTargets(name: kitName, platform: .iOS, dependencies: [.package(product: "StreamChat")])
let uiTarget = Project.makeFrameworkTargets(name: uiName, platform: .iOS, dependencies: [.package(product: "StreamChatSwiftUI"), .target(name: kitName)])

let authorizationTarget = Project.makeFrameworkTargets(name: authorizationName, platform: .iOS, dependencies: [.target(name: keychainName)])
let keychainHelperTarget = Project.makeFrameworkTargets(name: keychainName, platform: .iOS, dependencies: [])


// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "TwitterClone",
                          platform: .iOS,
                          packages: [.package(url: "https://github.com/GetStream/stream-chat-swiftui.git", .upToNextMajor(from: "4.0.0"))],
                          dependencies: [],
                          additionalTargets: kitTarget + uiTarget + authorizationTarget + keychainHelperTarget + messagesTarget + profileTarget + searchTarget + settingsTarget + timelineTarget + spacesTarget)


