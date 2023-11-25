import Foundation
import CoreData

protocol HeroToDAOMapperProtocol {
    func map(_ hero: Hero, context: NSManagedObjectContext) -> HeroDAO
}
