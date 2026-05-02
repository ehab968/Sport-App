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
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    private let baseURL = "https://apiv2.allsportsapi.com"
    private let apiKey = "8ad547d2b1135989a6411c40d8f3e7486790060b64d19f0d6c7859fdd56b5761"
    
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
}
