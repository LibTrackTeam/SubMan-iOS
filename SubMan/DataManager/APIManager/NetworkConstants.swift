//
//  NetworkConstants.swift
//  SubMan
//
//  Created by Hosny Savage on 23/10/2021.
//

import Foundation

struct NetworkingConstants {
    static let baseUrlEndpoint = ""

    static let networkErrorMessage = "Please check your internet connection and try again."


    static let getLanguages = "v1/languages"
    static let createAuthor = "v1/authors"
    static let createBook = "v1/books"
    static let getUserDetails = "v1/me?include=author,books"
    static let postScoop = "v1/scoops"


    func createPurchase(bookId: String) -> String {
        return "v1/app/pay/\(bookId)/books"
    }
}
