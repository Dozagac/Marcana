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

    // New properties for displaying error message
    @Published var errorMessage: String = ""
    @Published var errorTitle: String = ""
    @Published var showingError: Bool = false

    func restorePurchases() {
        Purchases.shared.restorePurchases { customerInfo, error in
            if let entitlement = customerInfo?.entitlements[Constants.entitlementID], entitlement.isActive {
                // The entitlement is now active for the user
                // TODO: show an alert
            } else if let error = error {
                // There was an error restoring purchases
                self.errorMessage = error.localizedDescription
                self.errorTitle = "Restore Purchase Error"
                self.showingError = true
                
                // print the error for debugging purposes
                print("Restore Purchase Error, descript ion: \(error.localizedDescription)")
                print("Restore Purchase Error, recovery suggestions: \(String(describing: error.localizedRecoverySuggestion))")
                print("Restore Purchase Error, reason: \(String(describing: error.localizedFailureReason))")
            } else {
                // The entitlement is not active for the user
                self.errorMessage = "User has no existing purchases to restore."
                self.errorTitle = "Restore Purchase Error"
                self.showingError = true
                
                print("User has no entitlement to restore.")
            }
        }
    }
}
