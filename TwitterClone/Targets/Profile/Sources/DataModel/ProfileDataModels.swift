//
//  ProfileDataModels.swift
//  TwitterClone
//
//  Created by Jeroen Leenarts on 26/01/2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation

// Profile data
struct MyProfileStructure: Identifiable {
    var id = UUID()
    var myName: String
    var myHandle: String
    var aboutMe: String
    var myLocation: String
    var myWebsite: String
    var myFollowing: String
    var myFollowers: String
    var dateJoined: String
}

let MyProfileData = [
    MyProfileStructure(myName: "Amos Gyamfi", myHandle: "@amos_gyamfi", aboutMe: "Developer Advocate", myLocation: "Financial Drive, Mississauga, ON", myWebsite: "getstream.io", myFollowing: "1009", myFollowers: "3347", dateJoined: "1929")
]

let FollowerProfileData = [
    MyProfileStructure(myName: "Jeroen the Leenarts", myHandle: "@appforce1", aboutMe: "DevRel Manager", myLocation: "Amsterdam", myWebsite: "getstream.io", myFollowing: "1000", myFollowers: "15k", dateJoined: "1852")
]

let UnfollowerProfileData = [
    MyProfileStructure(myName: "Stefan Kwaku Blos", myHandle: "@stefanjblos", aboutMe: "DevRel Manager", myLocation: "Amsterdam", myWebsite: "getstream.io", myFollowing: "256", myFollowers: "42k", dateJoined: "1809")
]
