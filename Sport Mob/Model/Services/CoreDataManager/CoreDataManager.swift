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
    func removeFavLeague(leagueId: Int) throws
    func isFav(leagueId: Int) throws -> Bool
}


class CoreDataManager : CoreDataManagerProtocol {
    
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    lazy var viewContext = persistentContainer.viewContext
//    lazy var privateContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()
    private init() {
        persistentContainer = NSPersistentContainer(name: "SportDataModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        viewContext.automaticallyMergesChangesFromParent = true
//        privateContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
    
    
    func removeFavLeague(leagueId: Int) throws {
        let request = LeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", leagueId)
        do {
            let results = try viewContext.fetch(request)
            for object in results {
                viewContext.delete(object)
            }
            try viewContext.save()
        }
        catch {
            print("Failed to remove favorite league: \(error)")
            throw error
        }
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
    
    func isFav(leagueId: Int) throws -> Bool {
        let request = LeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", leagueId)
        do {
            let results = try viewContext.fetch(request)
            return !results.isEmpty
        }
        catch {
            print("Failed to check if league is favorite: \(error)")
            throw error
        }
    }
}

// just an example of how to use background context with view context
extension CoreDataManager {
    
    //  ============ Background context saving example ===============
    
    
//    func saveFavLeagueBackground(league: League) throws {
//            privateContext.perform { [weak self] in
//                guard let self = self else { return }
//
//                let favLeague = LeagueEntity(context: self.privateContext)
//                favLeague.id = Int64(league.leagueKey)
//                favLeague.leagueName = league.leagueName
//                favLeague.leagueImage = league.leagueLogo
//                favLeague.countryName = league.countryName
//                favLeague.countryImage = league.countryLogo
//
//                do {
//                    try self.privateContext.save()
//                    print("CoreData Saved in background")
//                } catch {
//                    print("CoreData Error saving: \(error)")
//                }
//            }
//        }
    
}
