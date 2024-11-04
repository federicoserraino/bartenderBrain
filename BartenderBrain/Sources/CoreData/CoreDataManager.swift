//
//  CoreDataManager.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 03/11/24.
//

import Foundation
import CoreData

protocol CoreDataManager: AnyObject {
    func fetchCocktailIds() throws -> [String]
    func saveCocotailIds(_ ids: [String]) throws
}

class AppCoreDataManager: CoreDataManager {
    static let shared: CoreDataManager = AppCoreDataManager()
    private init() {}
    private let maxRoundsToStore: Int = 2 // Assume to store at most the last 2 rounds
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BartenderBrain")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchCocktailIds() throws -> [String] {
        let context = persistentContainer.viewContext
        let fetchRequest = GameRoundEntity.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.flatMap{ $0.cocktailIds }
        } catch {
            throw CoreDataError.fetchCocktailIdsError
        }
    }
    
    func saveCocotailIds(_ ids: [String]) throws {
        let context = persistentContainer.viewContext
        let fetchTimestampOrderedRequest = GameRoundEntity.fetchTimestampOrderedRequest()
        do {
            let entities = try context.fetch(fetchTimestampOrderedRequest)
            if entities.count == maxRoundsToStore, let oldestEntity = entities.first {
                context.delete(oldestEntity)
            }
            let newEntity = GameRoundEntity(context: context)
            newEntity.timestamp = Date().timeIntervalSince1970
            newEntity.cocktailIds = ids
            try context.save()
        } catch {
            throw CoreDataError.saveCocktailIds
        }
    }
}

