//
//  FavLeaguePresenter.swift
//  Sport Mob
//
//  Created by Ehab Salah on 07/05/2026.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import CoreData
protocol FavLeaguePresenterProtocol {
    func fetchFavLeaguesFromCoreData()
    func removeLeagueFromFav(at index: Int)
    func setupFRC()
    var favLeaguesDriver: Driver<[LeagueEntity]> { get }
    var errorDriver: Driver<String> { get }
    var removeSuccessDriver: Driver<Void> { get }
    var noFavDriver: Driver<[LeagueEntity]> { get }
    
}

class FavLeaguePresenter:NSObject, NSFetchedResultsControllerDelegate, FavLeaguePresenterProtocol{
    
    private let coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared
    private var fetchRescultsController: NSFetchedResultsController<LeagueEntity>!
    
    private let favLeaguesObservable = BehaviorRelay<[LeagueEntity]>(value: []) // => it requires an initial value
    private let errorMessage = PublishSubject<String>() // => it doesn't require an initial value, use it to send an event only
    private let removeSuccessState = PublishSubject<Void>()
    
    var favLeaguesDriver: Driver<[LeagueEntity]> {
        return favLeaguesObservable.asDriver()
    }
    var errorDriver: Driver<String> {
        return errorMessage.asDriver(onErrorJustReturn: "An unexpected error occurred")
    }
    var removeSuccessDriver: Driver<Void> {
        return removeSuccessState.asDriver(onErrorJustReturn: ())
    }
    var noFavDriver: Driver<[LeagueEntity]> {
        return favLeaguesObservable.asDriver()
    }
    
    override init() {
        super.init()
        setupFRC()
    }
    func fetchFavLeaguesFromCoreData(){
        do{
            let leagues :[LeagueEntity] = try coreDataManager.fetchFavLeagues()
            favLeaguesObservable.accept(leagues)
        }
        catch{
            errorMessage.onNext("Failed to fetch favorite leagues: \(error.localizedDescription)")
        }
    }
    
    func removeLeagueFromFav(at index: Int) {
        do{
            try coreDataManager.removeFavLeague(leagueId: Int(index))
            removeSuccessState.onNext(())
        }
        catch{
            errorMessage.onNext("Failed to remove league from favorites: \(error.localizedDescription)")
        }
    }
    
}




extension FavLeaguePresenter{
    func setupFRC() {
        let fetchRequest: NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        fetchRescultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchRescultsController.delegate = self
        
        do {
            try fetchRescultsController.performFetch()  // => it is the start button for FRC to start listening t
        } catch {
            print("FRC Initial Fetch Error: \(error)")
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        if let updatedLeagues = controller.fetchedObjects as? [LeagueEntity] {
            favLeaguesObservable.accept(updatedLeagues)
        }
    }
}
