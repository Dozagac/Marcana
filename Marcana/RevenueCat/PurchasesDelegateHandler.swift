//
//  PurchasesDelegateHandler.swift
//  Marcana
//
//  Created by Deniz Ozagac on 13/02/2023.
//

import Foundation
import RevenueCat

class PurchasesDelegateHandler: NSObject, ObservableObject{
    static let shared = PurchasesDelegateHandler()
}

extension PurchasesDelegateHandler: PurchasesDelegate{
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        UserSubscriptionManager.shared.customerInfo = customerInfo
    }
}
