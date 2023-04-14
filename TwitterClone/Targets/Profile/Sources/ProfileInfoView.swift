//
//  ProfileInfoView.swift
//  TwitterClone
//
//  Created by amos.gyamfi@getstream.io on 19.1.2023.
//  Copyright © 2023 Stream.io Inc.  All rights reserved.
//

import SwiftUI

import Feeds
import TwitterCloneUI

public class ProfileInfoViewModel: ObservableObject {

    @Published
    public var feedUser: FeedUser?

    var fullname: String {
        feedUser?.fullname ?? ""
    }

    var firstname: String {
        feedUser?.firstname ?? ""
    }

    var lastname: String {
        feedUser?.lastname ?? ""
    }

    var username: String {
        feedUser?.username ?? ""
    }

    var aboutMe: String {
        feedUser?.aboutMe ?? ""
    }

    var location: String {
        feedUser?.location ?? ""
    }

    var joinedDateString: String {
        formattedDate(date: feedUser?.createdAt)
    }

    public var profilePictureUrlString: String? {
        feedUser?.profilePicture
    }

    public init(feedUser: FeedUser? = nil) {
        self.feedUser = feedUser
    }
    
    let following = 10
    let followers = 11
    
    private func formattedDate(date: Date?) -> String {
        guard let date else {
            return "-"
        }
        
        return Formatter.uiDateFormatter.string(from: date)
    }
}

public struct ProfileInfoView: View {
    
    @ObservedObject var viewModel: ProfileInfoViewModel
    
    public init(viewModel: ProfileInfoViewModel) {
        self.viewModel = viewModel
    }
        
    public var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.fullname)
                .fontWeight(.bold)
            Text(viewModel.username)
                .font(.subheadline)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.aboutMe)
                    .font(.subheadline)
                HStack(spacing: 16) {
                    HStack(spacing: 2) {
                        Image(systemName: "mappin.and.ellipse")
                        Text(viewModel.location)
                    }
                    .font(.caption)

                    HStack(spacing: 2) {
                        Image(systemName: "calendar")
                        Text("Joined \(viewModel.joinedDateString)")
                    }
                    .font(.caption)
                }
                .foregroundColor(.secondary)

                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Text("\(viewModel.following)")
                            .fontWeight(.bold)
                        Text("Following")
                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)

                    HStack(spacing: 2) {
                        Text("\(viewModel.followers)")
                            .fontWeight(.bold)
                        Text("Followers")
                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)
                }
            }
            .padding(.top, 8)
        }
    }
}

struct ProfileInfoView_Previews: PreviewProvider {
    static let feedUser = FeedUser.previewUser()

    static var previews: some View {
        ProfileInfoView(viewModel: ProfileInfoViewModel(feedUser: feedUser))
            .preferredColorScheme(.dark)
    }
}
