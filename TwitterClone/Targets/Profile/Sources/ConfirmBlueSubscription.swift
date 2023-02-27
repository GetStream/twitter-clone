//
//  ConfirmBlueSubscription.swift
//  Profile
//
//  Created by amos.gyamfi@getstream.io on 20.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI

public struct ConfirmBlueSubscription: View {
    public init() {}
    
    @Environment(\.dismiss) var dismiss
    @State private var showingSuccessful = false
    @State private var showingBlueHome = false
    
    public var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 32) {
                    HStack {
                        Image("TwitterCloneLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .cornerRadius(8)
                        VStack(alignment: .leading) {
                            Text("Monthly Premium")
                                .font(.subheadline)
                                .bold()
                            Text("TwitterClone")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Subscription")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 32) {
                        HStack(alignment: .top) {
                            Text("DETAILS:")
                                .foregroundColor(.secondary)
                            Text("For testing purpose only. You will not be charged for confirming this purchase")
                        }
                        
                        HStack {
                            Text("Price:")
                                .foregroundColor(.secondary)
                            Text("€8.99")
                                .font(.caption)
                        }
                    }
                    .font(.caption)
                }
                
                Button {
                    showingSuccessful = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 21)
                            .frame(width: 160, height: 42)
                            .cornerRadius(24)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(
                                        colors: [.spacesBlue, .spacesViolet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        Text("Confirm")
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                .padding(.top, 64)
                .alert("You're all set. The purchase was successful", isPresented: $showingSuccessful) {
                    Button("OK") {
                        showingBlueHome.toggle()
                    }
                    .fullScreenCover(isPresented: $showingBlueHome, content: BlueHomeView.init)
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Text("TwitterClone")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Dismiss sheet if already active
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct ConfirmBlueSubscription_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmBlueSubscription()
    }
}
