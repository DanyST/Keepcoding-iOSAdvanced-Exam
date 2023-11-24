import Foundation

enum ApiConstants {
    static let baseURL = "https://dragonball.keepcoding.education/api"
    
    enum Header {
        enum Key {
            static let contentType = "Content-Type"
            static let authorization = "Authorization"
        }
        
        enum Value {
            static let aplicationJson = "application/json; charset=utf-8"
            static let basic = "Basic"
            static let bearer = "Bearer"
        }
    }
}
