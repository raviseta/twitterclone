//
//  TweetCell.swift
//  TwitterClone
//
//  Created by raviseta on 01/03/23.
//

import UIKit

protocol TweetCellAppearanceProtocol {
    func updateCellProperties(cellViewModel: TweetCellViewModel)
}

class TweetCell: BaseTableViewCell {
    
    //MARK: - Properties
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblTweet: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnLikes: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnActivity: UIButton!
    @IBOutlet weak var btnReTweet: UIButton!
    
    var cellViewModel: TweetCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension TweetCell: TweetCellAppearanceProtocol {
    func updateCellProperties(cellViewModel: TweetCellViewModel) {
        self.lblTweet.text = cellViewModel.tweet
        btnComment.setTitle(String(cellViewModel.comments), for: .normal)
        btnReTweet.setTitle(String(cellViewModel.reTweets), for: .normal)
        btnLikes.setTitle(String(cellViewModel.likes), for: .normal)
        btnActivity.setTitle(String(cellViewModel.activity), for: .normal)
    }
}
