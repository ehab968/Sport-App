//
//  NetworkManager.swift
//  Sport Mob
//
//  Created by Al3dwy on 28/04/2026.
//
import Foundation
import Alamofire


protocol NetworkManagerProtocol {
    func getData<T:Decodable>(endpoint : String,met : String,parameters: [String : Any]?)async throws-> T
    func isConnectedToInternet() -> Bool
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    private let baseURL = "https://apiv2.allsportsapi.com"
    private let apiKey = "396db0d904675e988101040735b0f22fc732e9ab5cbcebf01ea1c02e125b8b36"
    
    private init(){}
    
    
    func getData<T:Decodable>(
        endpoint : String,
        met : String,
        parameters: [String : Any]? = nil ,
    )async throws-> T{
        let fullUrl = baseURL + endpoint
        var finalParameters = parameters ?? [:]
        finalParameters["met"] = met
        finalParameters["APIkey"] = apiKey
        let result = try await AF.request(fullUrl, method: .get , parameters: finalParameters)
            .validate()
            .serializingDecodable(T.self)
            .value
        return result
    }
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
