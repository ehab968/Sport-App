//
//  Sport_MobTests.swift
//  Sport MobTests
//
//  Created by Al3dwy on 09/05/2026.
//

import XCTest
import Alamofire
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

class MockURLProtocol: URLProtocol {
    static var mockData: Data?
    static var mockResponse: HTTPURLResponse?
    static var mockError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = MockURLProtocol.mockResponse {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = MockURLProtocol.mockData {
                client?.urlProtocol(self, didLoad: data)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}

final class NetworkManagerMockTests: XCTestCase {
    var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Alamofire.Session(configuration: configuration)
        networkManager = NetworkManager(session: session)
    }
    
    override func tearDown() {
        networkManager = nil
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockResponse = nil
        MockURLProtocol.mockError = nil
        super.tearDown()
    }
    
    func testGetData_WithMockData_ReturnsSuccess() async throws {
       
        let jsonString = """
        {
            "success": 1,
            "result": [
                {
                    "league_key": 4,
                    "league_name": "UEFA Europa League",
                    "country_key": 1,
                    "country_name": "eurocups",
                    "league_logo": "https://apiv2.allsportsapi.com/logo/logo_leagues/4_uefa_europa_league.png",
                    "country_logo": null
                }
            ]
        }
        """
        MockURLProtocol.mockData = jsonString.data(using: .utf8)
        MockURLProtocol.mockResponse = HTTPURLResponse(
            url: URL(string: "https://apiv2.allsportsapi.com/football")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
       
        let response: LeaguesResponse = try await networkManager.getData(
            endpoint: APIEndpoints.football,
            met: "Leagues"
        )
        
       
        XCTAssertNotNil(response.result)
        XCTAssertEqual(response.result?.first?.leagueName, "UEFA Europa League")
        XCTAssertEqual(response.result?.first?.leagueKey, 4)
    }
    
    func testGetData_WithMockError_ThrowsError() async {
       
        MockURLProtocol.mockError = NSError(domain: "TestErrorDomain", code: 404, userInfo: nil)
        
        
        do {
            let _: LeaguesResponse = try await networkManager.getData(
                endpoint: APIEndpoints.football,
                met: "Leagues"
            )
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
