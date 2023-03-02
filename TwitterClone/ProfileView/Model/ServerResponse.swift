//
//  ServerResponse.swift
//  TwitterClone
//
//  Created by raviseta on 01/03/23.
//

import Foundation

// MARK: - Tweet Response

struct ServerResponse: Codable {
    let tweetArray: [Tweet]
    
    enum CodingKeys: String, CodingKey {
        case tweetArray = "data"
    }
}

struct Tweet: Codable, Equatable {
    let tweet: String
    let comments: Int
    let likes: Int
    let activity: Int
    let isMedia: Bool
    let url: String
    let reTweets: Int
}
