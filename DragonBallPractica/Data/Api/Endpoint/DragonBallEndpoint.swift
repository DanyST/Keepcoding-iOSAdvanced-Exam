//
//  Endpoint.swift
//  DragonBallPractica
//
//  Created by Luis Eduardo Herrera Lillo on 29-10-23.
//

import Foundation

typealias EndpointParameters = [String: Any?]

enum DragonBallEndpoint {
    case login
    case heroes(name: String?)
    case heroLocations(heroId: String)
}

extension DragonBallEndpoint {
    var method: HTTPMethod {
        switch self {
        case .login, .heroes, .heroLocations:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .heroes:
            return "/heros/all"
        case .heroLocations:
            return "/heros/locations"
        }
    }
    
    var parameters: EndpointParameters {
        switch self {
        case .login:
            return [:]
        case let .heroes(name):
            return ["name": name ?? ""]
        case let .heroLocations(heroId):
            return ["heroId": heroId]
        }
    }
}

extension DragonBallEndpoint {
    func request(with baseURL: URL) -> URLRequest? {
        let url = baseURL.appendingPathComponent(path)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems
        
        guard let urlByComponents = components.url else {
            return nil
        }
        var request = URLRequest(url: urlByComponents)
        request.httpMethod = method.rawValue
        request.httpBody = jsonBody
        
        return request
    }
    
    private var queryItems: [URLQueryItem]? {
        guard method == .get else { return nil }
        let queryItems = parameters.map {
            guard let value = $0.value else {
                return URLQueryItem(name: $0.key, value: nil)
            }
            
            let valueString = String(describing: value)
            return URLQueryItem(name: $0.key, value: valueString)
        }
        return queryItems
    }
    
    private var jsonBody: Data? {
        guard method == .post else { return nil }
        return try? JSONSerialization.data(
            withJSONObject: parameters,
            options: .prettyPrinted
        )
    }
}
