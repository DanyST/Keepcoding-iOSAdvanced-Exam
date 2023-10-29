//
//  ApiError.swift
//  DragonBallPractica
//
//  Created by Luis Eduardo Herrera Lillo on 29-10-23.
//

import Foundation

enum ApiError: Error {
    case unknown
    case statusError(Int?)
    case noData
    case decodingData
    case encodingData
    case parsingUrl
}
