//
//  ForYouFeedsView.swift
//  TTwin

import Feeds
import Profile

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
            do {
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
            } catch {
                print(error)
            }
        }
    }
}

public struct ForYouFeedsView: View {
    @EnvironmentObject var feedClient: FeedsClient
    @EnvironmentObject var profileInfoViewModel: ProfileInfoViewModel

    @StateObject private var viewModel = ForYouFeedsViewModel()

    private let feedType: FeedType
    
    public init(feedType: FeedType = .timeline) {
        self.feedType = feedType
    }

    public var body: some View {
        List(viewModel.activities) { item in
            let model = PostRowViewViewModel(item: item, profileInfoViewModel: profileInfoViewModel)
            PostRowView(model: model).onReceive(model.$liked) { liked in
                if liked {
                    Task {
                        try await feedClient.addLike(item.id)
                    }
                }
            }
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
