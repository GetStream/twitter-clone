import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

/*
                +-------------+
                |             |
                |     App     | Contains TwitterClone App target and TwitterClone unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

let kitName = "TwitterCloneKit"

let kitTarget = Project.makeFrameworkTargets(name: kitName, platform: .iOS, dependencies: [.package(product: "StreamChat")])
let uiTarget = Project.makeFrameworkTargets(name: "TwitterCloneUI", platform: .iOS, dependencies: [.package(product: "StreamChatSwiftUI"), .target(name: kitName)])
// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "TwitterClone",
                          platform: .iOS,
                          packages: [.package(url: "https://github.com/GetStream/stream-chat-swiftui.git", .upToNextMajor(from: "4.0.0"))],
                          dependencies: [],
                          additionalTargets: kitTarget + uiTarget)
