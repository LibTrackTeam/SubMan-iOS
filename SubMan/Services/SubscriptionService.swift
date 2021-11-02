//
//  SubscriptionService.swift
//  SubMan
//
//  Created by Joseph Acquah on 24/10/2021.
//

import Foundation

protocol SubscriptionServiceProtocol {
    func getSubscriptions()
    func createSubscription()
    func toggleArchiveSubscriptions()
    func deleteSubscription()
}

class SubscriptionService: SubscriptionServiceProtocol {
    func getSubscriptions() {}
    func createSubscription() {}
    func toggleArchiveSubscriptions() {}
    func deleteSubscription() {}
}
