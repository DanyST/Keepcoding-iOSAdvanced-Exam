import Foundation
import CoreData

protocol HeroLocationsToDAOMapperProtocol {
    func map(_ heroLocations: HeroLocations, heroDAO: HeroDAO, context: NSManagedObjectContext) -> [HeroLocationDAO]
}

