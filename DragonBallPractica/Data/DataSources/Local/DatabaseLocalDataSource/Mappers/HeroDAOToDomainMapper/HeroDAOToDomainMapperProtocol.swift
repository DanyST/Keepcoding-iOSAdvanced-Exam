import Foundation

protocol HeroDAOToDomainMapperProtocol {
    func map(_ heroDAO: HeroDAO) -> Hero
}
