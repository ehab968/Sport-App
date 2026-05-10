//
//  TeamDetailsPresenter.swift
//  Sport Mob
//
//  Created by Al3dwy on 09/05/2026.
//

import Foundation

protocol TeamDetailsPresenterProtocol {
    func fetchTeamDetails()async
    func getForwardsCount() -> Int
    func getDefendersCount() -> Int
    func getMidfieldersCount() -> Int
    func getGoalkeepersCount() -> Int
    func getForward(at index: Int) -> Player?
    func getDefender(at index: Int) -> Player?
    func getMidfielder(at index: Int) -> Player?
    func getGoalkeeper(at index: Int) -> Player?
    func getCoach() -> Coach?
    func getTeam() -> TeamsModel?
    
    
    
}
class TeamDetailsPresenter: TeamDetailsPresenterProtocol {
    
    
    private let networkManager: NetworkManagerProtocol
    private var forwards : [Player] = []
    private var defenders : [Player] = []
    private var midfielders : [Player] = []
    private var goalkeepers : [Player] = []
    private var coaches : Coach?
    private var team : TeamsModel?
    weak var  view: TeamDetailsViewProtocol?
    var teamId : String?
    
    
    init(teamId: String? = nil, view: TeamDetailsViewProtocol? = nil , networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.teamId = teamId
        self.view = view
        self.networkManager = networkManager
    }
   
    func fetchTeamDetails() async  {
        view?.showLoading()
        do {
           
            let TeamDetailsResponse: TeamsRsponse = try await networkManager.getData(
                endpoint: APIEndpoints.football,
                met: "Teams",
                parameters: [
                    "teamId": teamId ?? ""
                ]
            )
            let teamsModel = TeamDetailsResponse.result?.first
            self.team = teamsModel
            let players = teamsModel?.players ?? []
            self.goalkeepers = players.filter { $0.playerType == "Goalkeepers" }
            self.defenders = players.filter { $0.playerType == "Defenders" }
            self.midfielders = players.filter { $0.playerType == "Midfielders"}
            self.forwards = players.filter { $0.playerType == "Forwards" }
            self.coaches = teamsModel?.coaches?.first
            view?.setupHeader()
            view?.hideLoading()
            view?.reloadData()
            
        }catch{
            view?.hideLoading()
            view?.showError(message: error.localizedDescription)
        }
        
        
    }
    
    func getForwardsCount() -> Int {
        forwards.count
    }
    
    func getDefendersCount() -> Int {
        defenders.count
    }
    
    func getMidfieldersCount() -> Int {
        midfielders.count
    }
    
    func getGoalkeepersCount() -> Int {
        goalkeepers.count
    }
    
    func getForward(at index: Int) -> Player? {
        if index >= 0 && index < forwards.count {
                return forwards[index]
            }
            return nil
        
    }
    
    func getDefender(at index: Int) -> Player? {
        if index >= 0 && index < defenders.count {
            return defenders[index]
            }
            return nil
      
    }
    
    func getMidfielder(at index: Int) -> Player? {
        if index >= 0 && index < midfielders.count {
            return midfielders[index]
            }
            return nil
       
    }
    
    func getGoalkeeper(at index: Int) -> Player? {
        if index >= 0 && index < goalkeepers.count {
            return goalkeepers[index]
            }
            return nil
        
    }
    
    func getCoach() -> Coach? {
        return coaches
    }

    func getTeam() -> TeamsModel? {
        return team
    }

   
    
}

