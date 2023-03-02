//
//  ProfileViewModel.swift
//  TwitterClone
//
//  Created by raviseta on 01/03/23.
//

import Foundation
protocol ProfileViewModelProtocol: AnyObject {
    var reloadTableView: (() -> Void)? { get  set}
    var tweetArray: [Tweet] { get }
    func getCellViewModel(at indexPath: IndexPath) -> TweetCellViewModel
    func getTweetArray() async
    var showAPIError: ((Error) -> Void)? { get  set}
}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    // MARK: Properties
    var reloadTableView: (() -> Void)?
    private var tweetDataService: TweetDataServiceProtocol
    var tweetArray = [Tweet]()
    var showAPIError: ((Error) -> Void)?

    var tweetCellViewModels = [TweetCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    // MARK: Methods
    init(tweetDataService: TweetDataServiceProtocol) {
        self.tweetDataService = tweetDataService
    }
    
    var serverError: Error? {
        didSet {
            guard let serverError = serverError else {
                return
            }
            showAPIError?(serverError)
        }
    }
    
    func getTweetArray() async {
        do {
            let result = try await tweetDataService.getTweetData(api: .list)
            self.tweetArray = result
            self.createTweetCellModels()
        } catch {
            self.serverError = error
        }
    }
    
    private func createTweetCellModels() {
        var cellModels = [TweetCellViewModel]()
        for object in self.tweetArray {
            cellModels.append(createCellModel(tweet: object))
        }
        self.tweetCellViewModels = cellModels
    }
    
    private func createCellModel(tweet: Tweet) -> TweetCellViewModel {
        return TweetCellViewModel(tweet: tweet.tweet, comments: tweet.comments, likes: tweet.likes, activity: tweet.activity, isMedia: tweet.isMedia, url: tweet.url, reTweets: tweet.reTweets)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> TweetCellViewModel {
        return tweetCellViewModels[indexPath.row]
    }
}
