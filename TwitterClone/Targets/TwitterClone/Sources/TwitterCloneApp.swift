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
    
    init() {
        
        URLSession.shared.configuration.urlCache?.memoryCapacity = 400_000_000 // ~400 MB memory space
        URLSession.shared.configuration.urlCache?.diskCapacity = 1_000_000_000 // ~1GB disk cache space
    }
    
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

