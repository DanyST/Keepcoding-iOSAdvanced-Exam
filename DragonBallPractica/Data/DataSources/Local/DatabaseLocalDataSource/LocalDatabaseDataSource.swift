import Foundation
import CoreData

struct LocalDatabaseDataSource {
    private let coreDataStack: CoreDataStackProtocol
    private let heroDAOToDomainMapper: HeroDAOToDomainMapperProtocol
    private let heroToDAOMapper: HeroToDAOMapperProtocol
    
    init(
        coreDataStack: CoreDataStackProtocol = CoreDataStack.shared,
        heroDAOToDomainMapper: HeroDAOToDomainMapperProtocol = HeroDAOToDomainMapper(),
        heroToDAOMapper: HeroToDAOMapperProtocol = HeroToDAOMapper()
    ) {
        self.coreDataStack = coreDataStack
        self.heroDAOToDomainMapper = heroDAOToDomainMapper
        self.heroToDAOMapper = heroToDAOMapper
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
            let heroes = try  context.fetch(fetchRequest)
            return heroes.map { heroDAOToDomainMapper.map($0) }
        } catch {
            return []
        }
    }
}
