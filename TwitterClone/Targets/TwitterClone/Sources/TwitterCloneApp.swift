import SwiftUI
import StreamChatSwiftUI

import TwitterCloneUI
import TimelineUI
import HomeUI
import Auth
import AuthUI
import Feeds
import Profile
import Search

@main
struct TwitterCloneApp: App {
    
    @StateObject
    var feedClient = FeedsClient.productionClient(region: .euWest, auth: try! TwitterCloneAuth(baseUrl: "http://localhost:8080"))
    // swiftlint:disable:previous force_try
    //    var feedClient = FeedsClient.previewClient()
    
    var body: some Scene {
        WindowGroup {
            if feedClient.auth.authUser != nil {
                HomeView().environmentObject(feedClient)
            } else {
                StartView().environmentObject(feedClient)
            }
            
            // MARK: For previewing
        }
    }
}

