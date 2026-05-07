//
//  LeagueDetailsPresenter.swift
//  Sport Mob
//
//  Created by Al3dwy on 04/05/2026.
//

import Foundation
protocol LeagueDetailsPresenterProtocol {
    func fetchLeagueDetails() async
    func getItemsCount(for section: Int) -> Int
    func getMatch(at index: Int, for section: Int) -> LeagueDetails?
    func getTeam(at index : Int) -> TeamsModel?
}

class LeagueDetailsPresenter : LeagueDetailsPresenterProtocol {
    private var leagueId : String?
    private var sportEndpointName : String?
    private var nextMatchesList : [LeagueDetails] = []
    private var latestMatchesList : [LeagueDetails] = []
    private var teamsList : [TeamsModel] = []
    
    
    
    weak var view : LeagueDetailsProtocol?
    init(leagueId: String? = nil, sportEndpointName: String? = nil, view: LeagueDetailsProtocol? = nil) {
        self.leagueId = leagueId
        self.sportEndpointName = sportEndpointName
        self.view = view
    }
    
    func fetchLeagueDetails() async {
       
        view?.showLoading()
        
        let endpoint = self.sportEndpointName ?? APIEndpoints.football
        let id = self.leagueId ?? ""

        do {
          
            let nextResponse: LeagueDetailsResponse = try await NetworkManager.shared.getData(
                endpoint: endpoint,
                met: "Fixtures",
                parameters: [
                    "leagueId": id,
                    "from": DateHelper.today(),
                    "to": DateHelper.daysAhead(7)
                ]
            )
            
            
            let latestResponse: LeagueDetailsResponse = try await NetworkManager.shared.getData(
                endpoint: endpoint,
                met: "Fixtures",
                parameters: [
                    "leagueId": id,
                    "from": DateHelper.daysAgo(7),
                    "to": DateHelper.today()
                        
                ]
            )
            
            
            let teamsResponse : TeamsRsponse = try await
            NetworkManager.shared.getData(endpoint: endpoint, met: "Teams" ,  parameters: [
                "leagueId": id,
               
            ])

            
            self.nextMatchesList = nextResponse.result ?? []
            self.latestMatchesList = latestResponse.result ?? []
            self.teamsList = teamsResponse.result ?? []
            print("Next Matches Count: \(nextMatchesList.count)")
            print("Latest Matches Count: \(latestMatchesList.count)")
            
            view?.hideLoading()
            view?.reloadData()
            
        } catch {
            view?.hideLoading()
            view?.showError(message: error.localizedDescription)
        }
    }
    
    
    func getItemsCount(for section: Int) -> Int {
            switch section {
            case 0: return nextMatchesList.count
            case 1: return latestMatchesList.count
            case 2: return teamsList.count
            default: return 0
            }
        }

        func getMatch(at index: Int, for section: Int) -> LeagueDetails? {
            if section == 0 {
                return nextMatchesList[index]
            } else {
                return latestMatchesList[index]
            }
        }
    
    func getTeam(at index : Int) -> TeamsModel? {
        return teamsList[index]
    }
    
    
    
    
    
}

