import Foundation
import CoreData

protocol HeroLocationDAOToDomainMapperProtocol {
    func map(_ heroLocationDAO: HeroLocationDAO) -> HeroLocation
}
