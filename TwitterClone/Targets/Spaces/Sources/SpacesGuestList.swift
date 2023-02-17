//
//  SpacesGuestList.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 16.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct SpacesGuestList: View {
    var body: some View {
        List{
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
                            Text("Ruben Johansson Kaisaniemi")
                                .font(.caption)
                                .bold()
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundColor(.streamBlue)
                        }
                        Text("@ruben_helsinfors")
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
                
                HStack {
                    Image("profile8")
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Pentanen Jussi")
                                .font(.caption)
                                .bold()
                        }
                        Text("@stefanjblos")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Image("profile7")
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Carla2")
                                .font(.caption)
                                .bold()
                        }
                        Text("@usermain")
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
                
                HStack {
                    Image("profile12")
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Ama Fosuaa")
                                .font(.caption)
                                .bold()
                        }
                        Text("@fosuaAma")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Image("profile11")
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Kwasi Francis")
                                .font(.caption)
                                .bold()
                        }
                        Text("@kwasi12435")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .listRowSeparator(.hidden)
    }
}

struct SpacesGuestList_Previews: PreviewProvider {
    static var previews: some View {
        SpacesGuestList()
    }
}
