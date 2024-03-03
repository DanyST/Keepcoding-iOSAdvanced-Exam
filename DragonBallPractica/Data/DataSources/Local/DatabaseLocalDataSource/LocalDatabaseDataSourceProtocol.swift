import Foundation

protocol LocalDatabaseDataSourceProtocol {
    func add(hero: Hero)
    func add(heroes: Heroes)
    func getHeroes() -> Heroes
    func add(heroLocations: HeroLocations, to: Hero)
    func getHeroLocations(by: Hero) -> HeroLocations
}
