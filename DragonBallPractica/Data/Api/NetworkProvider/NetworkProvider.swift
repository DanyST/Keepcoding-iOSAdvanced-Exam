//
//  WebService.swift
//  DragonBallPractica
//
//  Created by Luis Eduardo Herrera Lillo on 29-10-23.
//

import Foundation

final class NetworkProvider {
    private let baseUrl = URL(string: "https://dragonball.keepcoding.education/api")
}

extension NetworkProvider: NetworkProviderProtocol {
    func request<T: Decodable>(
        of type: T.Type,
        from endpoint: DragonBallEndpoint,
        additionalHeaders: [String: String]?,
        then completion: @escaping ((Result<T, ApiError>)) -> Void
    ) {
        let jsonDecoder = JSONDecoder()
        request(
            from: endpoint,
            additionalHeaders: additionalHeaders
        ) { responseResult in
            DispatchQueue.global().async {
                let result: Result<T, ApiError>
                
                defer {
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
                
                switch responseResult {
                case let .success(data):
                    guard let model = try? jsonDecoder.decode(type, from: data) else {
                        result = .failure(.decodingData)
                        return
                    }
                    result = .success(model)
                    
                case let .failure(error):
                    result = .failure(error)
                }
            }
        }
    }
    
    func request(
        from endpoint: DragonBallEndpoint,
        additionalHeaders: [String: String]?,
        then completion: @escaping ((Result<Data, ApiError>)) -> Void
    ) {
        guard
            let baseUrl,
            var request = endpoint.request(with: baseUrl)
        else {
            completion(.failure(.parsingUrl))
            return
        }
        request.setValue(
            "application/json; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        var currentHeaders = request.allHTTPHeaderFields
        currentHeaders?.merge(additionalHeaders ?? [:]) { _, second in second }
        request.allHTTPHeaderFields = currentHeaders
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("response: \(String(describing: response))")
            
            let result: Result<Data, ApiError>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard error == nil else {
                result = .failure(.unknown)
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            guard
                let httpResponse,
                httpResponse.statusCode == 200
            else {
                result = .failure(.statusError(httpResponse?.statusCode))
                return
            }
            
            guard let data else {
                result = .failure(.noData)
                return
            }
            
            result = .success(data)
        }.resume()
    }
}
