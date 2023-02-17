//
//  SubscribeBlue.swift
//  TwitterClone
//
//  Created by amos.gyamfi@getstream.io on 2.2.2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import RevenueCat

public struct SubscribeBlue: View {
    var package: Package
    public init(package: Package) {
        self.package = package
    }
    
    public var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Get more out of Twitter Blue with exclusive features")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    HStack(alignment: .top) {
                        Image(systemName: "circle.slash")
                        VStack(alignment: .leading) {
                            Text("Ad-free articles")
                                .font(.headline)
                            Text("Read ad-free articles from popular websites with no pay walls")
                        }
                    }
                    
                    HStack(alignment: .top) {
                        Image(systemName: "flame")
                        VStack(alignment: .leading) {
                            Text("Top articles")
                                .font(.headline)
                            Text("Read ad-free articles from popular websites with no pay walls")
                        }
                    }
                    
                    HStack(alignment: .top) {
                        Image(systemName: "pin.circle")
                        VStack(alignment: .leading) {
                            Text("Custom navigation")
                                .font(.headline)
                            Text("Read ad-free articles from popular websites with no pay walls")
                        }
                    }
                    
                    HStack(alignment: .top) {
                        Image(systemName: "theatermask.and.paintbrush")
                        VStack(alignment: .leading) {
                            Text("Custom app icon and themes")
                                .font(.headline)
                            Text("Read ad-free articles from popular websites with no pay walls")
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                            Text("Blue")
                        }
                        .foregroundColor(.streamBlue)
                        
                    }
                }
                Button {
                    Purchases.shared.purchase(package: package) { transaction, customerInfo, error, userCancelled in
                        if customerInfo?.entitlements.all["your_entitlement_id"]?.isActive == true {
                            print("Bought")
                        }
                    }

                } label: {
                    Text("Subscribe for $2.99/month")
                    Image(systemName: "checkmark.seal.fill")
                }
                .buttonStyle(.bordered)
                .padding(.top, 32)
            }
        }
    }
}

//struct SubscribeBlue_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscribeBlue()
//    }
//}
