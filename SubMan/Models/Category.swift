//
//  Category.swift
//  SubMan
//
//  Created by Joseph Acquah on 24/10/2021.
//

import Foundation


struct Category : Codable {
    var id: Int
    var name: String
    var color: String
}

struct CategoryResponse: Codable {
    var status: Int
    var category: [Category]
}
