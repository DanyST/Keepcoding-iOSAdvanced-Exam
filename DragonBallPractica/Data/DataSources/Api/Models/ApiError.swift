import Foundation

enum ApiError: Error {
    case unknown
    case statusError(Int?)
    case noData
    case decodingData
    case encodingData
    case parsingUrl
    case parsingHeaders
    case noToken
}
