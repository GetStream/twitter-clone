//
//  RecentSearchesView.swift
//  Search
//
//  Created by amos.gyamfi@getstream.io on 24.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct RecentSearchesView: View {
    public init() {}
    
    public var body: some View {
        HStack {
            VStack {
                Image("kimmy")
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                Text("Kimmy L")
                    .font(.subheadline)
                    .bold()
                Text("@kimmy")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack {
                Image("stefan")
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                Text("Stefan")
                    .font(.subheadline)
                    .bold()
                Text("@jblos")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack {
                Image("martin")
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                Text("Martin M")
                    .font(.subheadline)
                    .bold()
                Text("@martinM")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack {
                Image("jared")
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                Text("Jared L")
                    .font(.subheadline)
                    .bold()
                Text("@jared")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack {
                Image("alice")
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                Text("Alice")
                    .font(.subheadline)
                    .bold()
                Text("@_alice")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack {
                Image("carla")
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                Text("Carla")
                    .font(.subheadline)
                    .bold()
                Text("@_carla")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }.frame(height: 150)
    }
}

struct RecentSearchesView_Previews: PreviewProvider {
    static var previews: some View {
        RecentSearchesView()
    }
}
