//
//  TweetCellViewModel.swift
//  TwitterClone
//
//  Created by raviseta on 01/03/23.
//

import Foundation

struct TweetCellViewModel {
    let tweet: String
    let comments: Int
    let likes: Int
    let activity: Int
    let isMedia: Bool
    let url: String
    let reTweets: Int
}
