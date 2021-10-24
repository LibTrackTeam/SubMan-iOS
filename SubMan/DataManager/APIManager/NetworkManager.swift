//
//  NetworkManager.swift
//  SubMan
//
//  Created by Hosny Savage on 23/10/2021.
//

import Foundation
import Alamofire

class DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()

    /// Encodes given Encodable value into an array or dictionary
    func encode<T>(_ value: T) throws -> Any where T: Encodable {
        let jsonData = try jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
}

class DictionaryDecoder {
    private let jsonDecoder = JSONDecoder()

    /// Decodes given Decodable type from given array or dictionary
    func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var body: [String: Any] { get }
    var headers: HTTPHeaders { get }
    var parameters: [String: Any] { get }
}

struct BaseError: Error {
    let data: Data?
    let httpUrlResponse: HTTPURLResponse
}

enum ApiError: Error {
    case invalidApiKey
    case deactivatedUser
    case userNotFound
    case internalServer
    case badRequest
    case forbidden
    case notFound
    case unauthorized
    case networkError
    case failed
    case sizeFull
}

struct NetworkRequestError: Error {
    let error: Error?

    var localizedDescription: String {
        return error?.localizedDescription ?? "Please check your internet connection and try again."
    }
}

class NetworkManager {
    func handleError(_ error: Error) throws {
        if error is BaseError {
            let baseError = error as! BaseError
            let statusCode = baseError.httpUrlResponse.statusCode
            switch statusCode {
            case 401:
                throw ApiError.unauthorized
            case 404:
                throw ApiError.notFound
            case 400:
                throw ApiError.badRequest
            case 99:
                throw ApiError.invalidApiKey
            case 98:
                throw ApiError.userNotFound
            case 97:
                throw ApiError.deactivatedUser
            case 405:
                throw ApiError.failed
            case 500:
                throw ApiError.internalServer
            case 403:
                throw ApiError.sizeFull
            case 502:
                throw ApiError.notFound
            default:
                print("Default Error")
                throw ApiError.notFound
            }
        } else if error is NetworkRequestError {
            throw ApiError.networkError
        }
    }

    func getErrorMessage<T>(response: DataResponse<T, AFError>) -> String where T: Codable {
        var message = NetworkingConstants.networkErrorMessage
        if let data = response.data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
                print(json)
                if let error = json["errors"] as? NSDictionary {
                    message = error["message"] as! String
                } else if let error = json["error"] as? NSDictionary {
                    if let message1 = error["message"] as? String {
                        message = message1
                    }
                } else if let messages = json["message"] as? String {
                    message = messages
                } else if response.response!.statusCode == 400 {
                    message = "Your session has timed out."
                } else if response.response!.statusCode == 502 {
                    message = "Internal Server Error"
                }

            }
        }
        print("Error Desc: \(response.error?.localizedDescription)")
        print("Error Code0: \(response.error?.asAFError?.failureReason) \(response.response) \(response.response?.statusCode)")
        return message
    }
}
