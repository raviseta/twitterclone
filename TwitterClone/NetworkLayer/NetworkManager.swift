//
//  NetworkManager.swift
//  TwitterClone
//
//  Created by raviseta on 01/03/23.
//

import Foundation

protocol NetworkManagerProtocol {
    func initiateServiceRequest(url: URL) async throws -> Data
}

class NetworkManager: NetworkManagerProtocol {
   
    func initiateServiceRequest(url: URL) async throws -> Data {
        
        guard  let path = Bundle.main.path(forResource: "Tweet", ofType: "json")
        else {
            throw APIError.unknown
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return data
        } catch {
            throw APIError.unknown
        }
    }
}
