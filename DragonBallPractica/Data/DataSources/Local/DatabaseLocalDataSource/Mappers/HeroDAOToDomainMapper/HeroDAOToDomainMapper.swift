import Foundation

struct HeroDAOToDomainMapper: HeroDAOToDomainMapperProtocol {
    func map(_ heroDAO: HeroDAO) -> Hero {
        Hero(
            id: heroDAO.id ?? UUID().uuidString,
            name: heroDAO.name ?? "",
            isFavorite: heroDAO.isFavorite,
            photo: heroDAO.photo,
            description: heroDAO.heroDescription
        )
    }
}
