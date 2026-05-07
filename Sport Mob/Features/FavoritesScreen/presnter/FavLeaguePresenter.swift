//
//  FavLeaguePresenter.swift
//  Sport Mob
//
//  Created by Ehab Salah on 07/05/2026.
//

import Foundation
import RxSwift
import RxRelay
protocol FavLeaguePresenterProtocol {
    func fetchFavLeaguesFromCoreData()
}

class FavLeaguePresenter{
    private let coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared
    let favLeaguesObservable = BehaviorRelay<[LeagueEntity]>(value: []) // => it requires an initial value, so we start with an empty array
    let errorMessage = PublishSubject<String>() // => it doesn't require an initial value, use it to send an event only
    
    func fetchFavLeaguesFromCoreData(){
        do{
            let leagues :[LeagueEntity] = try coreDataManager.fetchFavLeagues()
            favLeaguesObservable.accept(leagues)
        }
        catch{
            errorMessage.onNext("Failed to fetch favorite leagues: \(error.localizedDescription)")
        }
    }
    
}
