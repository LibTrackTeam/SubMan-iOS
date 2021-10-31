//
//  Subscription.swift
//  SubMan
//
//  Created by Joseph Acquah on 24/10/2021.
//

import Foundation


struct Subscription: Codable {
    var id: Int
    var description: String
    var pricePerCycle: Double
    var cycle: String
    var billDate: String
    var archived: Bool
    var service: Service
    var categories: [Category]
    var reminder: String
    
    enum CodingKeys: String, CodingKey {
        case id, description, cycle, archived, service, categories, reminder
        case pricePerCycle = "price_per_cycle"
        case billDate = "bill_date"
    }
}
