import Foundation

protocol HeroDTOToDomainMapperProtocol {
    func map(_ heroDTO: HeroDTO) -> Hero?
}
