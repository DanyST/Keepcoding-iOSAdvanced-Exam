import Foundation
import CoreData

struct HeroToDAOMapper: HeroToDAOMapperProtocol {
    func map(_ hero: Hero, context: NSManagedObjectContext) -> HeroDAO {
        let heroDAO = HeroDAO(context: context)
        heroDAO.id = hero.id
        heroDAO.name = hero.name
        heroDAO.isFavorite = hero.isFavorite
        heroDAO.photo = hero.photo
        heroDAO.heroDescription = hero.description
        
        return heroDAO
    }
}
