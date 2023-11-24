import Foundation

typealias HeroesDTO = [HeroDTO]

struct HeroDTO: Decodable {
    let id: String?
    let favorite: Bool?
    let name: String?
    let photo: String?
    let description: String?
}
