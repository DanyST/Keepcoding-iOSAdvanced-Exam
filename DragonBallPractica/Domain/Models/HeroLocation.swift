import Foundation

typealias HeroLocations = [HeroLocation]

struct HeroLocation {
    let id: String
    let latitude: String
    let longitude: String
    let dateShow: String?
    let hero: Hero
}
