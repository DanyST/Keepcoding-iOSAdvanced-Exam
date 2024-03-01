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
        completion: @escaping (Result<[Hero], ApiError>) -> Void
    )
    
    func getHeroLocations(
        by hero: Hero,
        token: String,
        completion: @escaping (Result<[HeroLocation], ApiError>) -> Void
    )
}
