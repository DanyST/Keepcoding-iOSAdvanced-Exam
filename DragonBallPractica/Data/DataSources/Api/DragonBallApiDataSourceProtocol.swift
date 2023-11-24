import Foundation

protocol DragonBallApiDataSourceProtocol {
    func login(
        for user: String,
        with password: String,
        then completion: @escaping (Result<String, ApiError>) -> Void
    )
    
    func getHeroes(
        withName name: String?,
        token: String,
        completion: @escaping (Result<[HeroDTO], ApiError>) -> Void
    )
}
