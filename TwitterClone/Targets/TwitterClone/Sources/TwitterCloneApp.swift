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
    var profileInfoViewModel = ProfileInfoViewModel()
    
    @StateObject
    var feedsClient = FeedsClient.productionClient(region: .euWest, auth: try! TwitterCloneAuth(baseUrl: "http://localhost:8080"))
    // swiftlint:disable:previous force_try
    //    var feedClient = FeedsClient.previewClient()
    
    var body: some Scene {
        WindowGroup {
            if feedsClient.auth.authUser != nil {
                HomeView().environmentObject(feedsClient).environmentObject(profileInfoViewModel)
                    .task {
                        profileInfoViewModel.feedUser = try? await feedsClient.user()
                    }
            } else {
                StartView().environmentObject(feedsClient)
            }
            // MARK: For previewing
        }
    }
}

