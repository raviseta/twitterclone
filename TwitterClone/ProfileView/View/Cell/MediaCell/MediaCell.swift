//
//  ImageCell.swift
//  TwitterClone
//
//  Created by raviseta on 01/03/23.
//

import UIKit
import SDWebImage

class MediaCell: BaseTableViewCell {
    
    //MARK: - Properties
    @IBOutlet weak var ivTweetImage: UIImageView!
    @IBOutlet weak var lblTweet: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    var cellViewModel: TweetCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension MediaCell: TweetCellAppearanceProtocol {
    func updateCellProperties(cellViewModel: TweetCellViewModel) {
        self.lblTweet.text = cellViewModel.tweet
        if let imageURL = URL(string: cellViewModel.url) {
            if imageURL.pathExtension == "mp4" {
                btnPlay.isHidden = false
            }
            self.ivTweetImage.contentMode = .scaleAspectFill
            self.ivTweetImage.sd_setImage(with: imageURL,
                                          placeholderImage: UIImage(named: Constants.Image.placeholderImage),
                                          options: .transformAnimatedImage, context: nil)
        }
    }
}
