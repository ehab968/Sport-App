//
//  CoreDataManager.swift
//  Sport Mob
//
//  Created by Ehab Salah on 28/04/2026.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func saveFavLeague(league : League) throws
    func fetchFavLeagues() throws -> [LeagueEntity]
}


class CoreDataManager : CoreDataManagerProtocol {
    
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    lazy var viewContext = persistentContainer.viewContext
    private init() {
        persistentContainer = NSPersistentContainer(name: "SportDataModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveFavLeague(league : League) throws {
        let favLeague = LeagueEntity(context: viewContext)
        favLeague.id = Int64(league.leagueKey)
        favLeague.leagueName = league.leagueName
        favLeague.leagueImage = league.leagueLogo
        favLeague.countryName = league.countryName
        favLeague.countryImage = league.countryLogo
        
        try viewContext.save()
    }
    func fetchFavLeagues() throws -> [LeagueEntity] {
        let request = LeagueEntity.fetchRequest()
        do {
            let favLeagues = try viewContext.fetch(request)
            return favLeagues
        }
        catch {
            print("Failed to fetch favorite leagues: \(error)")
            throw error
        }
    }
        
}
