import Foundation

struct HeroLocationDTOToDomainMapper: HeroLocationDTOToDomainMapperProtocol {
    func map(_ heroLocationDTO: HeroLocationDTO, with hero: Hero) -> HeroLocation? {
        guard
            let latitude = heroLocationDTO.latidude,
            let longitude = heroLocationDTO.longitude,
            let id = heroLocationDTO.id
        else {
            return nil
        }
        let heroLocation = HeroLocation(
            id: id,
            latitude: latitude,
            longitude: longitude,
            dateShow: heroLocationDTO.dateShow,
            hero: hero
        )
        
        return heroLocation
    }
}
