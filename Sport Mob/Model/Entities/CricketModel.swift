//
//  CricketModel.swift
//  Sport Mob
//
//  Created by Al3dwy on 09/05/2026.
//

import Foundation


struct CricketResponse: Codable {
    let success: Int?
    let result: [CricketTeam]?
}


struct CricketTeam: Codable {
    let teamKey: Int?
    let teamName: String?
    let teamLogo: String?

    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
    
    }



}
