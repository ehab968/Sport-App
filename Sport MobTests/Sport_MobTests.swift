//
//  Sport_MobTests.swift
//  Sport MobTests
//
//  Created by Al3dwy on 09/05/2026.
//

import XCTest
@testable import Sport_Mob

final class NetworkManagerIntegrationTests: XCTestCase {
    
    var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()
        networkManager = NetworkManager.shared
    }

    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }

   
    func testGetData_Leagues_ReturnsSuccess() async throws {
        let response: LeaguesResponse = try await networkManager.getData(
            endpoint: APIEndpoints.football,
            met: "Leagues"
        )
        XCTAssertNotNil(response.result)
    }

   
    func testGetData_Teams_ReturnsSuccess() async throws {
        let params: [String: Any] = ["leagueId": "152"] 
        
        let response: TeamsRsponse = try await networkManager.getData(
            endpoint: APIEndpoints.football,
            met: "Teams",
            parameters: params
        )
        
        XCTAssertNotNil(response.result)
        XCTAssertFalse(response.result?.isEmpty ?? true)
    }

    
    func testGetData_Fixtures_ReturnsSuccess() async throws {
        let params: [String: Any] = [
            "leagueId": "152",
            "from": "2026-05-01",
            "to": "2026-05-30"
        ]
        
        let response: LeagueDetailsResponse = try await networkManager.getData(
            endpoint: APIEndpoints.football,
            met: "Fixtures",
            parameters: params
        )
        
        XCTAssertNotNil(response.result)
    }
}
