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
    func addLeagueToFavorites(league: League)
}

class LeaguePresenter: LeaguePresenterProtocol {
    
    weak var view: LeagueTableViewControllerProtocol?
    private let networkManager = NetworkManager.shared
    private let coreDataManager = CoreDataManager.shared
    private var leagues : [League] = []
    var sportEndpointName : String

    init(view: LeagueTableViewControllerProtocol?, sportEndpointName: String) {
        self.view = view
        self.sportEndpointName = sportEndpointName
    }

    func fetchLeagues() async{
        view?.showLoading()
        do{
            let response: LeaguesResponse = try await networkManager.getData(endpoint: sportEndpointName, met: "Leagues")
            leagues = response.result
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
                try coreDataManager.saveFavLeague(league: league)
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
}

extension LeaguePresenter {
    func getleaguesCount() -> Int {
        leagues.count
    }
    
    func getLeague(at index: Int) -> League {
        return leagues[index]
    }
    
}
