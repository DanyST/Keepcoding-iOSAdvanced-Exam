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
    func login(for user: String, with password: String) {
        
    }
}
