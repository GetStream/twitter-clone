//
//  BlueHomeView.swift
//  Profile
//
//  Created by amos.gyamfi@getstream.io on 20.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct BlueHomeView: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            TabView {
                VStack(alignment: .leading, spacing: 32) {
                    HStack {
                        Text("Blue")
                            .font(.largeTitle)
                            .fontWeight(.black)
                        Spacer()
                        Label("Active", systemImage: "checkmark.seal.fill")
                            .bold()
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(lineWidth: 2))
                    }
                    .foregroundColor(.streamBlue)
                    
                    HStack {
                        Text("Feature settings")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    
                    List {
                        HStack {
                            Image(systemName: "arrow.uturn.backward")
                            VStack(alignment: .leading) {
                                Text("Undo Tweet")
                                    .font(.title3)
                                    .bold()
                                Text("Select the tweets you would like to undo before they are public")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        NavigationLink(destination: BlueHomeView()) {
                            HStack {
                                Image(systemName: "paintbrush.pointed")
                                VStack(alignment: .leading) {
                                    Text("Theme")
                                        .font(.title3)
                                        .bold()
                                    Text("Choose a unique color for your TwitterClone experience")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        HStack {
                            Image(systemName: "character.cursor.ibeam")
                            VStack(alignment: .leading) {
                                Text("Dynamic Text Size")
                                    .font(.title3)
                                    .bold()
                                Text("Select your preferred text size when reading threads")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        HStack {
                            Image(systemName: "platter.2.filled.iphone")
                            VStack(alignment: .leading) {
                                Text("Customize App Icon")
                                    .font(.title3)
                                    .bold()
                                Text("Choose a custom-made app icon to display on your home screen")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        HStack {
                            Image(systemName: "pin")
                            VStack(alignment: .leading) {
                                Text("Customize Your Navigation")
                                    .font(.title3)
                                    .bold()
                                Text("Select your prefered navigation bar icons and background color")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                    }
                }
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("TwitterClone Blue")
                                .font(.title3)
                                .bold()
                            Text("@stefabjblos")
                                .font(.caption)
                        }
                    }
                }
                .tabItem {
                    Image(systemName: "house")
                }
                
                Text("")
                    .tabItem {
                        Image("spacesTabBarIcon1")
                    }
                    
                Text("")
                    .tabItem {
                        Image(systemName: "bell")
                    }
                    .badge(10)
                    
                Text("")
                    .tabItem {
                        Image(systemName: "text.bubble")
                    }
            }
            .padding()
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
    
    struct BlueHomeView_Previews: PreviewProvider {
        static var previews: some View {
            BlueHomeView()
        }
    }
