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

    static let signIn = "/api/user"
}


struct UserParam: Codable {
    var uid: String
    var messageToken: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case messageToken = "message_token"
    }
}

struct UserResponse: Codable {
    var status: Int
    var user: UserParam
}
