import Foundation
import CoreData

struct LocalDatabaseDataSource {
    private let coreDataStack: CoreDataStackProtocol
    private let heroDAOToDomainMapper: HeroDAOToDomainMapperProtocol
    private let heroToDAOMapper: HeroToDAOMapperProtocol
    private let heroLocationDAOToDomainMapper: HeroLocationDAOToDomainMapperProtocol
    private let heroLocationsToDAOMapper: HeroLocationsToDAOMapperProtocol
    
    init(
        coreDataStack: CoreDataStackProtocol = CoreDataStack.shared,
        heroDAOToDomainMapper: HeroDAOToDomainMapperProtocol = HeroDAOToDomainMapper(),
        heroToDAOMapper: HeroToDAOMapperProtocol = HeroToDAOMapper(),
        heroLocationDAOToDomainMapper: HeroLocationDAOToDomainMapperProtocol = HeroLocationDAOToDomainMapper(),
        heroLocationsToDAOMapper: HeroLocationsToDAOMapperProtocol = HeroLocationsToDAOMapper()
    ) {
        self.coreDataStack = coreDataStack
        self.heroDAOToDomainMapper = heroDAOToDomainMapper
        self.heroToDAOMapper = heroToDAOMapper
        self.heroLocationDAOToDomainMapper = heroLocationDAOToDomainMapper
        self.heroLocationsToDAOMapper = heroLocationsToDAOMapper
    }
}

extension LocalDatabaseDataSource: LocalDatabaseDataSourceProtocol {
    func add(hero: Hero) {
        let context = coreDataStack.persistentContainer.viewContext
        _ = heroToDAOMapper.map(hero, context: context)
        
        do {
            try context.save()
        } catch {
            assertionFailure("Error saving context")
        }
    }
    
    func add(heroes: Heroes) {
        guard !heroes.isEmpty else { return }
        heroes.forEach { add(hero: $0) }
    }
    
    func getHeroes() -> Heroes {
        let context = coreDataStack.persistentContainer.viewContext
        
        let fetchRequest = HeroDAO.fetchRequest()
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        
        do {
            let heroesDAO = try  context.fetch(fetchRequest)
            return heroesDAO.map { heroDAOToDomainMapper.map($0) }
        } catch {
            return []
        }
    }
    
    func add(heroLocations: HeroLocations, to hero: Hero) {
        guard !heroLocations.isEmpty else { return }
        let context = coreDataStack.persistentContainer.viewContext
                
        do {
            guard let heroDAO = getHeroDAO(by: hero.id) else {
                assertionFailure("Error fetching heroDAO")
                return
            }
            
            _ = heroLocationsToDAOMapper.map(heroLocations, heroDAO: heroDAO, context: context)
                       
            try context.save()
        } catch {
            assertionFailure("Error saving context")
        }
    }
    
    func getHeroLocations(by hero: Hero) -> HeroLocations {
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest = HeroLocationDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "hero.id = %@", hero.id)
        
        do {
            let heroLocationsDAO = try context.fetch(fetchRequest)
            return heroLocationsDAO.map { heroLocationDAOToDomainMapper.map($0) }
        } catch {
            return []
        }
    }
}

private extension LocalDatabaseDataSource {
    func getHeroDAO(by id: String) -> HeroDAO? {
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest = HeroDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let heroDAO = try context.fetch(fetchRequest).first
            return heroDAO
        } catch {
            return nil
        }
    }
}
