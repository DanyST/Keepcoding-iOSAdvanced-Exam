import Foundation
import CoreData

struct HeroLocationsToDAOMapper: HeroLocationsToDAOMapperProtocol {
    func map(_ heroLocations: HeroLocations, heroDAO: HeroDAO, context: NSManagedObjectContext) -> [HeroLocationDAO] {
        heroLocations.map {
            let heroLocationDAO = HeroLocationDAO(context: context)
            heroLocationDAO.id = $0.id
            heroLocationDAO.latitude = $0.latitude
            heroLocationDAO.longitude = $0.longitude
            heroLocationDAO.dateShow = $0.dateShow
            heroLocationDAO.hero = heroDAO
            return heroLocationDAO
        }
    }
}
