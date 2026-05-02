//
//  SportsPresenter.swift
//  Sport Mob
//
//  Created by Ehab Salah on 28/04/2026.
//

import Foundation

protocol SportsPresenterProtocol {
    func getEndpoint(at index: Int) -> String
}

class SportsPresenter: SportsPresenterProtocol {
    func getEndpoint(at index: Int) -> String {
        switch index {
        case 0: return APIEndpoints.football
        case 1: return APIEndpoints.basketball
        case 2: return APIEndpoints.tennis
        case 3: return APIEndpoints.cricket
        default: return ""
        }
    }
}
