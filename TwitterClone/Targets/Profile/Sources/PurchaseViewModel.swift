//
//  PurchaseManager.swift
//  Profile
//
//  Created by Jeroen Leenarts on 13/02/2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import SwiftUI
import Foundation
import RevenueCat
import Auth

public class PurchaseViewModel: ObservableObject {
    @Published
    var offerings: Offerings?
    
    @Published
    var isSubscriptionActive = false

    public init() {
//        Purchases.logLevel = .debug
    }

    public func configure(userId: String?) {
        let configuration = Configuration.Builder(withAPIKey: "appl_ffoirKXwYnVnlhIlEaExRfMZxxf")
            .with(appUserID: userId)
            .with(usesStoreKit2IfAvailable: true)
            .build()
        Purchases.configure(with: configuration)
        
        Purchases.shared.getCustomerInfo { customerInfo, error in
            self.isSubscriptionActive = customerInfo?.entitlements.all["blue"]?.isActive == true
            if let error {
                print(error)
            }

        }
        
        Purchases.shared.getOfferings { offerings, error in
            if let offerings {
                self.offerings = offerings
            }
            if let error {
                print(error)
            }
        }
    }
}
