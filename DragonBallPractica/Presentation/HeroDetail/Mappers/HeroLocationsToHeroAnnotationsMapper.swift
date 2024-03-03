import Foundation

struct HeroLocationsToHeroAnnotationsMapper: HeroLocationsToHeroAnnotationsMapperProtocol {
    func map(_ heroLocations: HeroLocations, with hero: Hero) -> [HeroAnnotation] {
        heroLocations.map {
            HeroAnnotation(
                title: hero.name,
                info: hero.id,
                coordinate: .init(
                    latitude: Double($0.latitude) ?? 0.0,
                    longitude: Double($0.longitude) ?? 0.0
                )
            )
        }
    }
}
