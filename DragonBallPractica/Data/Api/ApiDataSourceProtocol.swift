//
//  ApiDataSourceProtocol.swift
//  DragonBallPractica
//
//  Created by Luis Eduardo Herrera Lillo on 29-10-23.
//

import Foundation

protocol ApiDataSourceProtocol {
    func login(for user: String, with password: String)
}
