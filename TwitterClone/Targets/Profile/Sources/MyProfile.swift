//
//  MyProfile.swift
//  TwitterClone
//

import SwiftUI

import TwitterCloneUI
import Feeds

public struct MyProfile<FooterContent: View>: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var feedsClient: FeedsClient
    @EnvironmentObject var profileInfoViewModel: ProfileInfoViewModel
    @State private var isShowingEditProfile = false

    let footerContent: FooterContent

    public init() where FooterContent == EmptyView {
        self.footerContent = EmptyView()
    }

    public init(footerContent: () -> FooterContent) {
        self.footerContent = footerContent()
    }

    public var body: some View {
        PopoverView(title: "My Profile") {
            myProfileView
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        // Link to the settings page
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gearshape.2")
                        }
                    }
                }
        }
    }

    var myProfileView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    ProfileImage(imageUrl: profileInfoViewModel.profilePictureUrlString, action: {})
                            .scaleEffect(1.2)

                    Spacer()

                    Button {
                        isShowingEditProfile.toggle()
                        print("Navigate to edit profile page")
                    } label: {
                        Text("Edit profile")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .sheet(isPresented: $isShowingEditProfile, content: {
                        if let feedUser = profileInfoViewModel.feedUser {
                            EditProfileView(currentUser: feedUser)
                        }
                    })
                    .buttonStyle(.borderedProminent)
                }

                ProfileInfoView(viewModel: profileInfoViewModel)

                // Optional additional footer content
                footerContent
            }.padding()
        }
    }
}

struct MyProfile_Previews: PreviewProvider {
    static let feedUser = FeedUser.previewUser()
    
    static var previews: some View {
        MyProfile()
            .environmentObject(ProfileInfoViewModel(feedUser: feedUser))
            .preferredColorScheme(.dark)
    }
}
