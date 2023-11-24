//
//  NetworkProviderProtocol.swift
//  DragonBallPractica
//
//  Created by Luis Eduardo Herrera Lillo on 29-10-23.
//

import Foundation

protocol NetworkProviderProtocol {
    func request<T: Decodable>(
        of type: T.Type,
        from endpoint: DragonBallEndpoint,
        additionalHeaders: [String: String]?,
        then completion: @escaping ((Result<T, ApiError>)) -> Void
    )
    func request(
        from endpoint: DragonBallEndpoint,
        additionalHeaders: [String: String]?,
        then completion: @escaping ((Result<Data, ApiError>)) -> Void
    )
}
