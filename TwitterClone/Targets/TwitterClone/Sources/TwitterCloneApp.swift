import SwiftUI

import StreamChatSwiftUI

import TwitterCloneUI
import TwitterCloneAuth

@main
struct TwitterCloneApp: App {
    var body: some Scene {
        WindowGroup {
            HomeTimelineView()
        }
    }
}
