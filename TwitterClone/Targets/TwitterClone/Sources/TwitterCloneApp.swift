import SwiftUI

import StreamChatSwiftUI

import TwitterCloneUI
import TwitterCloneAuth
import TwitterCloneAuthUI
import TwitterCloneFeeds

@main
struct TwitterCloneApp: App {
    
    @StateObject
    var auth = TwitterCloneAuth()
    
    @StateObject
    var feedClient = FeedsClient.productionClient(region: .euWest)
    
    var body: some Scene {
        WindowGroup {
            if auth.authUser != nil {
                HomeTimelineView().environmentObject(feedClient)
            } else {
                StartView().environmentObject(auth)
            }
            
            
            // MARK: For previewing
            //LogIn()
            //StartView()
            //MyProfile()
        }
    }
}
