import Foundation
import CoreData

protocol CoreDataStackProtocol {
    var persistentContainer: NSPersistentContainer { get }
}

final class CoreDataStack: CoreDataStackProtocol {
    // Singleton
    static let shared: CoreDataStack = .init()

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DragonBallModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
