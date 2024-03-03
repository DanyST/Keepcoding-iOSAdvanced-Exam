import Foundation

struct HeroLocationsToHeroAnnotationsMapper: HeroLocationsToHeroAnnotationsMapperProtocol {
    func map(_ heroLocations: HeroLocations) -> [HeroAnnotation] {
        heroLocations.map {
            HeroAnnotation(
                title: $0.hero.name,
                info: $0.hero.id,
                coordinate: .init(
                    latitude: Double($0.latitude) ?? 0.0,
                    longitude: Double($0.longitude) ?? 0.0
                )
            )
        }
    }
}
