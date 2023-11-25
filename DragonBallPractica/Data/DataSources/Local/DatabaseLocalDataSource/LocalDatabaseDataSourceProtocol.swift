import Foundation

protocol LocalDatabaseDataSourceProtocol {
    func add(hero: Hero)
    func add(heroes: Heroes)
    func getHeroes() -> Heroes
}
