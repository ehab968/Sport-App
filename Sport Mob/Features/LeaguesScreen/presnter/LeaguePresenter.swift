//
//  LeaguePresenter.swift
//  Sport Mob
//
//  Created by Ehab Salah on 02/05/2026.
//

import Foundation

protocol LeaguePresenterProtocol {
    func fetchLeagues() async
    func getleaguesCount() -> Int
    func getLeague(at index: Int) -> League
    var sportEndpointName : String { get set }
    func addLeagueToFavorites(league: League)
    func isLeagueFav(at index : Int) -> Bool
    func removeLeagueFromFav(at index: Int)
    func filterLeagues(with text: String)
}

class LeaguePresenter: LeaguePresenterProtocol {
    
    
    
    weak var view: LeagueTableViewControllerProtocol?
    private let networkManager : NetworkManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared
    private var leagues : [League] = []
    private var filteredLeagues : [League] = []
    var sportEndpointName: String

    init(view: LeagueTableViewControllerProtocol?, sportEndpointName: String ,
         networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.view = view
        self.sportEndpointName = sportEndpointName
        self.networkManager = networkManager
    }

    func fetchLeagues() async{
        guard networkManager.isConnectedToInternet() else {
            view?.hideLoading()
            view?.showOfflineAlert()
            return
        }
        view?.showLoading()
        do{
            let response: LeaguesResponse = try await networkManager.getData(endpoint: sportEndpointName, met: "Leagues", parameters: nil)
            leagues = response.result ?? []
            filteredLeagues = leagues
            view?.hideLoading()
            view?.reloadData()
        }
        catch{
            view?.hideLoading()
            view?.showError(message: error.localizedDescription)
        }
        
    }
    func addLeagueToFavorites(league: League) {
        Task(priority: .background){
            do{
                try coreDataManager.saveFavLeague(league: league, sportEndpoint: sportEndpointName)
                await MainActor.run{
                    view?.onSaveLeagueSuccess()
                }
            }
            catch{
                await MainActor.run{
                    view?.onSaveLeagueFailure(message: "Failed to save league: \(error.localizedDescription)")
                }
            }
        }
    }
    func isLeagueFav(at index : Int) -> Bool{
        let league = leagues[index]
        do{
            return try coreDataManager.isFav(leagueId: league.leagueKey ?? 0)
        }
        catch {
            print("Error checking if league is favorite: \(error)")
            return false
        }
    }
    func removeLeagueFromFav(at index: Int) {
        let league = leagues[index]
        Task(priority: .background){
            do{
                try coreDataManager.removeFavLeague(leagueId: league.leagueKey ?? 0)
                view?.onRemoveLeagueSuccess()
            }
            catch{
                print("Failed to remove favorite league: \(error)")
                view?.showError(message: "Failed to remove league from favorites: \(error.localizedDescription)")
            }
        }
    }
}

extension LeaguePresenter {
    func getleaguesCount() -> Int {
        filteredLeagues.count
    }
    
    func getLeague(at index: Int) -> League {
        return filteredLeagues[index]
    }
    
    func filterLeagues(with text: String) {
        if text.isEmpty {
            filteredLeagues = leagues
        } else {
            filteredLeagues = leagues.filter { $0.leagueName?.lowercased().contains(text.lowercased()) ?? false }
        }
        view?.reloadData()
    }
}
