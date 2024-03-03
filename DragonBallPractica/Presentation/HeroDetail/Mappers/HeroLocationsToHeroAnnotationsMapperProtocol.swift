import Foundation

protocol HeroLocationsToHeroAnnotationsMapperProtocol {
    func map(_ heroLocations: HeroLocations, with hero: Hero) -> [HeroAnnotation]
}
