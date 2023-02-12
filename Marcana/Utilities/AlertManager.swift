//
//  AlertManager.swift
//  Marcana
//
//  Created by Deniz Ozagac on 12/02/2023.
//

import SwiftUI
import Network

class AlertManager: ObservableObject {
    static let shared = AlertManager()
    @Published var showNoInternetAlert = false

    private init() {
        checkInternetConnection()
    }
    
    func checkInternetConnection() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .unsatisfied {
                DispatchQueue.main.async {
                    self?.showNoInternetAlert = true
                }
            } else {
                DispatchQueue.main.async {
                    self?.showNoInternetAlert = false
                }
            }
        }
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.start(queue: queue)
    }
}
