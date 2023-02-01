import SwiftUI
import StreamChatSwiftUI

import TwitterCloneUI
import Timeline
import Auth
import AuthUI
import Feeds
import Profile

@main
struct TwitterCloneApp: App {
    
    @StateObject
    var feedClient = FeedsClient.productionClient(region: .euWest, auth: try! TwitterCloneAuth(baseUrl: "http://localhost:8080"))
    // swiftlint:disable:previous force_try    
    //    var feedClient = FeedsClient.previewClient()
    
    var body: some Scene {
        WindowGroup {
            if feedClient.auth.authUser != nil {
                HomeTimelineView().environmentObject(feedClient)
            } else {
                StartView().environmentObject(feedClient)
            }
            
            // MARK: For previewing
            // LogIn()
            // StartView()
            // MyProfile()
            // ProfileFollower()
            // ProfileUnfollower()
            // ProfileSideMenu()
            // AddNewTweetView()
            // ProfileSummaryView()
            // EditProfileView()
            // MediaPickerView()
        }
    }
}

