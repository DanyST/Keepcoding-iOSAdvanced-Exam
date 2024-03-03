import Foundation

protocol HeroLocationsToHeroAnnotationsMapperProtocol {
    func map(_ heroLocations: HeroLocations) -> [HeroAnnotation]
}
