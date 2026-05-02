//
//  LeaguePresenter.swift
//  Sport Mob
//
//  Created by Ehab Salah on 02/05/2026.
//

import Foundation

protocol LeaguePresenterProtocol {
    func fetchLeagues(endpoint : String) async
    func getleaguesCount() -> Int
    func getLeague(at index: Int) -> League
}

class LeaguePresenter: LeaguePresenterProtocol {
    
    weak var view: LeagueTableViewControllerProtocol?
    private let networkManager = NetworkManager.shared
    private var leagues : [League] = []

    init(view: LeagueTableViewControllerProtocol?) {
        self.view = view
    }

    func fetchLeagues(endpoint : String) async{
        view?.showLoading()
        do{
            let response: LeaguesResponse = try await networkManager.getData(endpoint: endpoint, met: "Leagues")
            leagues = response.result
            view?.hideLoading()
            view?.reloadData()
        }
        catch{
            view?.hideLoading()
            view?.showError(message: error.localizedDescription)
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
