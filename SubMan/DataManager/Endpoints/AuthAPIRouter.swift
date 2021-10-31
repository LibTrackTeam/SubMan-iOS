//
//  AuthAPIRouter.swift
//  SubMan
//
//  Created by Joseph Acquah on 31/10/2021.
//

import Foundation
import Alamofire

enum AuthAPIRouter: APIConfiguration, URLConvertible {
    case signIn(userParam: UserParam)
    
    internal var method: HTTPMethod {
        switch self {
        case .signIn:
            return .post
        }
    }
    
    internal var path: String {
        switch self {
        case .signIn:
            return NetworkingConstants.signIn
        }
    }
    
    internal var body: [String: Any] {
        switch self {
        default:
            return [:]
        }
    }
    
    internal var headers: HTTPHeaders {
        switch self {
        default:
            return [:]
        }
    }
    
    internal var parameters: [String: Any] {
        switch self {
        case .signIn(let parameter):
            var param: [String: Any] = [:]
            do {
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String: Any]
            } catch {
                print("Couldnt parse parameter")
            }
            return param
        default:
            return [:]
        }
    }
    
    func asURL() throws -> URL {
        var urlComponents: URLComponents!
        switch self {
        default:
            urlComponents = URLComponents(string: NetworkingConstants.baseUrlEndpoint + path)
        }
        
        var queryItems: [URLQueryItem] = []
        for item in parameters {
            queryItems.append(URLQueryItem(name: item.key, value: "\(item.value)"))
        }
        if(!(queryItems.isEmpty)) {
            urlComponents.queryItems = queryItems
        }
        
        let url = urlComponents.url!
        return url
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: "https://google.com")
        return URLRequest(url: url!)
    }
}
