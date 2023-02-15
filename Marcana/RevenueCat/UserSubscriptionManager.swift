//
//  UserViewModel.swift
//  Marcana
//
//  Created by Deniz Ozagac on 13/02/2023.
//  https://www.youtube.com/watch?v=WLVUGYFkL3Q  

import Foundation
import RevenueCat
import SwiftUI

/* Static shared model for UserView */
class UserSubscriptionManager: ObservableObject {
    static let shared = UserSubscriptionManager()
    
    /* The latest CustomerInfo from RevenueCat. Updated by PurchasesDelegate whenever the Purchases SDK updates the cache */
    @Published var customerInfo: CustomerInfo? {
        didSet {
            // checks if the subscription is active 12:10 in the video
            subscriptionActive = customerInfo?.entitlements[Constants.entitlementID]?.isActive == true
        }
    }
    
    /* The latest offerings - fetched from MarcanaApp.swift on app launch */
    @Published var offerings: Offerings? = nil
    
    /* Set from the didSet method of customerInfo above, based on the entitlement set in Constants.swift */
    @Published var subscriptionActive: Bool = false

    
    func restorePurchases() {
        Purchases.shared.restorePurchases { customerInfo, error in
            if let entitlement = customerInfo?.entitlements[Constants.entitlementID], entitlement.isActive {
                // The entitlement is now active for the user
                // TODO: show an alert
            } else if let error = error {
                // There was an error restoring purchases
                print("Restore Purchase Error, description: : \(error.localizedDescription)")
                print("Restore Purchase Error, recovery suggestions: : \(String(describing: error.localizedRecoverySuggestion))")
                print("Restore Purchase Error, reason: : \(String(describing: error.localizedFailureReason))")
            } else {
                // The entitlement is not active for the user
                print("User has no entitlement to restore.")
                // TODO: show an alert
            }
        }
    }

}
