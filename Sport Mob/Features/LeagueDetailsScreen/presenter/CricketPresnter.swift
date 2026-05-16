//
//  CricketPresnter.swift
//  Sport Mob
//
//  Created by Al3dwy on 09/05/2026.
//

import Foundation
protocol CricketPresenterProtocol {
    func fetchCricketMatches() async
    func getItemsCount() -> Int
    func getMatch(at index: Int) -> CricketTeam?
    
}

class CricketPresenter : CricketPresenterProtocol {
    private let networkManager : NetworkManagerProtocol
    private var leagueId : String?
    private var sportEndpointName : String?
    private var cricketTeams : [CricketTeam] = []
    weak var view : CricketTableViewControllerProtocol?
    init(leagueId: String? = nil, sportEndpointName: String? = nil, view: CricketTableViewControllerProtocol? = nil , networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.leagueId = leagueId
        self.sportEndpointName = sportEndpointName
        self.view = view
        self.networkManager = networkManager
    }
    
   
    func fetchCricketMatches() async {
        guard networkManager.isConnectedToInternet() else {
            view?.hideLoading()
            view?.showOfflineAlert()
            return
        }
        view?.showLoading()
        
        let endpoint = self.sportEndpointName ?? APIEndpoints.football
        let id = self.leagueId ?? ""

       
            do {
            let cricketTeamsResponse: CricketResponse =
            try await networkManager.getData(
                endpoint: endpoint,
                met: "Teams",
                parameters: [
                    "leagueId": id,
                ]
            )
                self.cricketTeams = cricketTeamsResponse.result ?? []
                view?.hideLoading()
                view?.reloadData()
        }catch {
           view?.hideLoading()
           view?.showError(message: error.localizedDescription)
        }
       
    }
    
    
    func getItemsCount() -> Int {
        return cricketTeams.count
        }

        func getMatch(at index: Int) -> CricketTeam? {
           return cricketTeams[index]
        }
    
  
    
    
    
    
}
