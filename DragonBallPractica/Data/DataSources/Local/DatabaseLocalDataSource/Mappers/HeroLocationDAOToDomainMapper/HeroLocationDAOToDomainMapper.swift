import Foundation

struct HeroLocationDAOToDomainMapper: HeroLocationDAOToDomainMapperProtocol {
    func map(_ heroLocationDAO: HeroLocationDAO) -> HeroLocation {
        HeroLocation(
            id: heroLocationDAO.id ?? UUID().uuidString,
            latitude: heroLocationDAO.latitude ?? "",
            longitude: heroLocationDAO.longitude ?? "",
            dateShow: heroLocationDAO.dateShow,
            hero: Hero(
                id: heroLocationDAO.hero?.id ?? UUID().uuidString,
                name: heroLocationDAO.hero?.name ?? "",
                isFavorite: heroLocationDAO.hero?.isFavorite ?? false,
                photo: heroLocationDAO.hero?.photo,
                description: heroLocationDAO.hero?.heroDescription
            )
        )
    }
}
