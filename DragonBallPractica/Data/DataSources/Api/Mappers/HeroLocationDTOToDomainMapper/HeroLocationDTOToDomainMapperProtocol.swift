import Foundation

protocol HeroLocationDTOToDomainMapperProtocol {
    func map(_ heroLocationDTO: HeroLocationDTO, with hero: Hero) -> HeroLocation?
}
