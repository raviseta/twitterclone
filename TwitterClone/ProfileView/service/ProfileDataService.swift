//
//  ProfileDataService.swift
//  TwitterClone
//
//  Created by raviseta on 01/03/23.
//

import Foundation

enum ProfileAPI {
    case list
    var apiURL: String {
        switch self {
        case .list:
            return Constants.URLs.baseURL + Constants.URLs.profileEndpoints
        }
    }
}

protocol TweetDataServiceProtocol {
    func getTweetData(api: ProfileAPI) async throws -> [Tweet]
}

class TweetDataService: TweetDataServiceProtocol {
    private var networkManager: NetworkManagerProtocol
    
    init(withNetworkManager: NetworkManagerProtocol) {
        self.networkManager = withNetworkManager
    }
    
    
    func getTweetData(api: ProfileAPI) async throws -> [Tweet] {
        do {
            // Check if api url is correct
            let url = try createProfileURL(api: api)
            let responseData = try await self.networkManager.initiateServiceRequest(url: url)
            let dictData = try self.parseServerResponseData(serverResponseData: responseData)
            return dictData.tweetArray
        } catch {
            throw error
        }
    }
    
    private func createProfileURL(api: ProfileAPI) throws -> URL {
        guard let components = URLComponents(string: api.apiURL) else {
            throw APIError.invalidURL
        }
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        return url
    }
    
    private func parseServerResponseData(serverResponseData: Data?) throws -> ServerResponse {
        guard let data = serverResponseData
        else {  throw APIError.responseError }
        do {
            let dict = try JSONDecoder().decode(ServerResponse.self, from: data)
            return dict
        } catch {
            throw APIError.responseError
        }
    }
}
