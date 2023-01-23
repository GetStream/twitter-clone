import SwiftUI

import StreamChatSwiftUI

import TwitterCloneUI
import TwitterCloneAuth

@main
struct TwitterCloneApp: App {
    
    @StateObject
    var auth = TwitterCloneAuth()
    
    var body: some Scene {
        WindowGroup {
            if auth.authUser != nil {
                HomeTimelineView().environmentObject(auth)
            } else {
                StartView().environmentObject(auth)
            }
        }
    }
}
