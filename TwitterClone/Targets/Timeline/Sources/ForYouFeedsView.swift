//
//  ForYouFeedsView.swift
//  TTwin

import Feeds

import SwiftUI

public struct ForYouFeedsView: View {
    @EnvironmentObject var feedClient: FeedsClient
    
    public init() {}
    
    public var body: some View {
        List(feedClient.activities) {
            item in
            PostView(item: item)
        } //LIST STYLES
        .listStyle(.plain)
        .onAppear {
            Task {
                // TODO: switch between the right feeds depending on context
                do {
                    try await feedClient.getActivities()
                } catch {
                    print(error)
                }
            }
        }
        .refreshable {
            do {
                try await feedClient.getActivities()
            } catch {
                print(error)
            }
        }
    }
}

struct ForYouFeedsView_Previews: PreviewProvider {
    static var feedClient = FeedsClient.previewClient()
    static var previews: some View {
        ForYouFeedsView()
            .environmentObject(feedClient)
            .preferredColorScheme(.dark)
    }
}
