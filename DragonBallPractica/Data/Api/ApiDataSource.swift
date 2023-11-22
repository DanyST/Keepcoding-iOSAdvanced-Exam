//
//  ApiProvider.swift
//  DragonBallPractica
//
//  Created by Luis Eduardo Herrera Lillo on 29-10-23.
//

import Foundation

final class ApiDataSource {
    private let networkProvider: NetworkProviderProtocol
    
    init(networkProvider: NetworkProviderProtocol) {
        self.networkProvider = networkProvider
    }
}

extension ApiDataSource: ApiDataSourceProtocol {
    func login(
        for user: String,
        with password: String,
        then completion: @escaping (Result<String, ApiError>) -> Void
    ) {
        guard let loginData = String(format: "%@:%@", user, password)
            .data(using: .utf8)?
            .base64EncodedString()
        else {
            completion(.failure(.parsingHeaders))
            return
        }        
        let authorizationHeader = ["Authorization": "Basic \(loginData)"]        
        networkProvider.request(from: .login, additionalHeaders: authorizationHeader) { result in
            switch result {
            case let .success(data):
                guard let token = String(data: data, encoding: .utf8) else {
                    completion(.failure(.decodingData))
                    return
                }
                completion(.success(token))
            case let.failure(error):
                completion(.failure(error))
            }
        }
    }
}