import SwiftUI

import Feeds

struct FeedsView: View {
    @EnvironmentObject var feedClient: FeedsClient
    
    @State private var selection = 0
    
    var body: some View {
        VStack {
            ForYouFeedsView()
        }
    }
}

struct FeedsView_Previews: PreviewProvider {
    static var feedClient = FeedsClient.previewClient()
    static var previews: some View {
        FeedsView()
            .environmentObject(feedClient)
            .preferredColorScheme(.dark)
    }
}
