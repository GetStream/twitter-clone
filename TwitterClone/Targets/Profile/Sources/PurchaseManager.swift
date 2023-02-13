//
//  PurchaseManager.swift
//  Profile
//
//  Created by Jeroen Leenarts on 13/02/2023.
//  Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation
import RevenueCat
import Auth

public class PurchaseManager: ObservableObject {
    public init() {
        Purchases.logLevel = .debug
    }
    
    public func configure(userId: String?) {
        Purchases.configure(withAPIKey: "appl_ffoirKXwYnVnlhIlEaExRfMZxxf", appUserID: userId)
        
        Purchases.shared.getOfferings { offerings, error in
            if let offerings {
                print(offerings)
            }
            if let error {
                print(error)
            }
        }
    }
}
