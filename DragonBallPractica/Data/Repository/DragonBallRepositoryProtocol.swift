import Foundation

protocol DragonBallRepositoryProtocol {
    func login(
        for user: String,
        with password: String,
        then completion: @escaping (Result<String, ApiError>) -> Void
    )
    
    func getHeroes(withName name: String?, completion: @escaping (Result<Heroes, ApiError>) -> Void)
    
    func getHeroLocations(by hero: Hero, completion: @escaping (Result<[HeroLocation], ApiError>) -> Void)
    
    @discardableResult
    func saveLocalSecure(_ keyType: SecureLocalType, value: String) -> Bool
    
    func getLocalSecure(_ keyType: SecureLocalType) -> String?
    
    func deleteLocalSecure(_ keyType: SecureLocalType) -> Bool
    
    func saveHeroesInLocalDatabase(_ heroes: Heroes)
    
    func getHeroesFromDatabase() -> Heroes
    
    func saveHeroLocationsInLocalDatabase(_ heroLocations: HeroLocations, to hero: Hero)
    
    func getHeroLocationsFromDataBase(by hero: Hero) -> HeroLocations
}
