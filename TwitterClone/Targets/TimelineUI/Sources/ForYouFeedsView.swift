//
//  ForYouFeedsView.swift
//  TTwin

import Feeds

import SwiftUI

public enum FeedType {
    case user(userId: String?)
    case timeline
}
@MainActor
private class ForYouFeedsViewModel: ObservableObject {
    internal var type: FeedType = .timeline
    internal var feedClient: FeedsClient?
    
    @Published public var activities: [EnrichedPostActivity] = []
    
    func refreshActivities() {
        Task {
            if let feedClient = self.feedClient {
                activities.removeAll()
                switch type {
                case .timeline:
                    activities = try await feedClient.getTimelineActivities()
                case .user(let userId):
                    if let userId {
                        activities = try await feedClient.getUserActivities(userId: userId)
                    }
                }
            }
        }
    }
}

public struct ForYouFeedsView: View {
    @EnvironmentObject var feedClient: FeedsClient
    @StateObject private var viewModel = ForYouFeedsViewModel()

    private let feedType: FeedType
    
    public init(feedType: FeedType = .timeline) {
        self.feedType = feedType
    }

    public var body: some View {
        List(viewModel.activities) { item in
            PostRowView(item: item)
        } // LIST STYLES
        .listStyle(.plain)
        .task {
            viewModel.type = feedType
            viewModel.feedClient = feedClient
            viewModel.refreshActivities()
        }
        .refreshable {
            viewModel.refreshActivities()
        }
    }
}

// struct ForYouFeedsView_Previews: PreviewProvider {
//    static var feedClient = FeedsClient.previewClient()
//    static var previews: some View {
//        ForYouFeedsView()
//            .environmentObject(feedClient)
//            .preferredColorScheme(.dark)
//    }
// }
