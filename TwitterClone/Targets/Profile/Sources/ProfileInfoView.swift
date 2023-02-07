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

class ProfileInfoViewModel: ObservableObject {
    @Published var feedUser: FeedUser?
    
    let location = "Amsterdam"
    let following = 10
    let followers = 11
    
    func formattedDate(date: Date?) -> String {
        guard let date else {
            return "-"
        }
        
        return Formatter.uiDateFormatter.string(from: date)
    }
}

struct ProfileInfoView: View {
    
    @ObservedObject var viewModel: ProfileInfoViewModel
        
    var body: some View {
        VStack(alignment: .leading) {
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
                        Text("\(viewModel.location)")
                    }
                    .font(.caption)

                    HStack(spacing: 2) {
                        Image(systemName: "calendar")
                        Text("Joined \(viewModel.formattedDate(date: viewModel.feedUser?.createdAt))")
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

// struct ProfileInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileInfoView(myProfile: MyProfileData)
//            .preferredColorScheme(.dark)
//    }
// }
