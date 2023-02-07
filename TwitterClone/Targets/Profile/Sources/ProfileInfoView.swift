//
//  ProfileInfoView.swift
//  TwitterClone
//
//  Created by amos.gyamfi@getstream.io on 19.1.2023.
//  Copyright © 2023 Stream.io Inc.  All rights reserved.
//

import SwiftUI

import Feeds

class ProfileInfoViewModel: ObservableObject {
    @Published var feedUser: FeedUser?
}

struct ProfileInfoView: View {
    
    @ObservedObject var viewModel: ProfileInfoViewModel
    
    var myProfile: MyProfileStructure?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if let profile = myProfile {
                Text(viewModel.feedUser?.fullname ?? "")
                    .fontWeight(.bold)
                Text(viewModel.feedUser?.username ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.feedUser?.aboutMe ?? "")
                        .font(.subheadline)
                    HStack(spacing: 16) {
                        HStack(spacing: 2) {
                            Image(systemName: "mappin.and.ellipse")
                            Text("\(profile.myLocation)")
                        }
                        .font(.caption)

                        HStack(spacing: 2) {
                            Image(systemName: "calendar")
                            Text("Joined June \(profile.dateJoined)")
                        }
                        .font(.caption)
                    }
                    .foregroundColor(.secondary)

                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Text("\(profile.myFollowing)")
                                .fontWeight(.bold)
                            Text("Following")
                                .foregroundColor(.secondary)
                        }
                        .font(.subheadline)

                        HStack(spacing: 2) {
                            Text("\(profile.myFollowers)")
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
}

// struct ProfileInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileInfoView(myProfile: MyProfileData)
//            .preferredColorScheme(.dark)
//    }
// }
