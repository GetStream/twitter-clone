//
//  SpacesGuestsView.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 16.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct SpacesGuestsView: View {
    @State private var selection = 0
    @Environment(\.dismiss) var dismiss
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack {
                Picker("For You and Following picker", selection: $selection) {
                    Text("Co-hosts").tag(0)
                    Text("All").tag(1)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Listeners")
                            .font(.headline)
                            .bold()
                        
                        Text("156 people on TwitterClone are listening")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button {
                            
                        } label: {
                            Text("Learn more")
                        }
                        .font(.caption)
                    }
                    
                    Spacer()
                }
                
                // MARK: Display the content under each picker
                if selection == 0 {
                    List {
                        VStack(alignment: .leading) {
                            HStack {
                                Image("profile1")
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Stefan Blos")
                                            .font(.caption)
                                            .bold()
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.caption)
                                            .foregroundColor(.streamBlue)
                                    }
                                    Text("@stefanjblos")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            HStack {
                                Image("jared")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 36, height: 36)
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Jared")
                                            .font(.caption)
                                            .bold()
                                    }
                                    Text("@jaredL")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            HStack {
                                Image("kimmy")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 36, height: 36)
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Kimmy")
                                            .font(.caption)
                                            .bold()
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.caption)
                                            .foregroundColor(.streamBlue)
                                    }
                                    Text("@kimmyL")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            HStack {
                                Image("ruben")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 36, height: 36)
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Ruben")
                                            .font(.caption)
                                            .bold()
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.caption)
                                            .foregroundColor(.streamBlue)
                                    }
                                    Text("@ruben_francis")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            HStack {
                                Image("profile10")
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Akua Serwaa")
                                            .font(.caption)
                                            .bold()
                                    }
                                    Text("@stefanjblos")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                        }
                    }
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
                    .scrollContentBackground(.hidden)
                    
                } else {
                        SpacesGuestList()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Guests")
                            .bold()
                        HStack(spacing: 4) {
                            Image(systemName: "person.fill")
                                .bold()
                            Text("199")
                        }
                    }
                    .font(.caption)
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
    }
}

struct SpacesGuestsView_Previews: PreviewProvider {
    static var previews: some View {
        SpacesGuestsView()
    }
}
