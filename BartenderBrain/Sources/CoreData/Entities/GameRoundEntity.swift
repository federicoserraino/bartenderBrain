//
//  GameRoundEntity.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 03/11/24.
//

import Foundation
import CoreData

@objc(GameRound)
public class GameRoundEntity: NSManagedObject {
    @NSManaged public var timestamp: TimeInterval
    @NSManaged public var cocktailIds: [String]
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameRoundEntity> {
        return NSFetchRequest<GameRoundEntity>(entityName: "GameRound")
    }
    
    @nonobjc public class func fetchTimestampOrderedRequest() -> NSFetchRequest<GameRoundEntity> {
        let request = NSFetchRequest<GameRoundEntity>(entityName: "GameRound")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        return request
    }
}
