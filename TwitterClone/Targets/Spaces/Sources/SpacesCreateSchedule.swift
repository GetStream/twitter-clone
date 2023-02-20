//
//  SpacesCreateSchedule.swift
//  Spaces
//
//  Created by amos.gyamfi@getstream.io on 17.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct SpacesCreateSchedule: View {
    @State private var isShowingNameField = ""
    @Environment(\.dismiss) var dismiss
    @State private var spaceDate = Date.now
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                DatePicker(selection: $spaceDate, in: Date.now..., displayedComponents: .date) {
                    Text("Select date")
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Dismiss sheet
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Schedule Space")
                            .font(.headline)
                        Text("All about iOS")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        //
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: 100, height: 32)
                                .cornerRadius(24)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(
                                            colors: [.spacesBlue, .spacesViolet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                            Text("Schedule")
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct SpacesCreateSchedule_Previews: PreviewProvider {
    static var previews: some View {
        SpacesCreateSchedule()
    }
}
