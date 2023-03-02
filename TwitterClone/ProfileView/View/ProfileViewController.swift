//
//  ViewController.swift
//  TwitterClone
//
//  Created by raviseta on 01/03/23.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tblFeed: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!

    private lazy var viewModel: ProfileViewModelProtocol = {
       ProfileViewModel(tweetDataService: TweetDataService(withNetworkManager: NetworkManager()))
    }() as ProfileViewModelProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
    }
    
    private func configureView() {
        setTableViewProperties()
    }
    
    private func setTableViewProperties() {
        tblFeed.delegate = self
        tblFeed.dataSource = self
        tblFeed.register(TweetCell.nib, forCellReuseIdentifier: TweetCell.identifier)
        tblFeed.register(MediaCell.nib, forCellReuseIdentifier: MediaCell.identifier)
        self.tblFeed.tableHeaderView = self.tableHeaderView
        self.tblFeed.tableHeaderView = nil
        self.tblFeed.contentInset = UIEdgeInsets(top: Constants.Value.SCREEN_WIDTH / 2, left: 0, bottom: 0, right: 0)
        self.tblFeed.addSubview(tableHeaderView)
        tableHeaderView.frame.size.width = Constants.Value.SCREEN_WIDTH
    }
    
    private func configureViewModel() {
        fetchTweets()
        
        // All callbacks from view models
        handleTableviewRefreshActivity()
    }
}

extension ProfileViewController {
    private func fetchTweets() {
        Task {[weak self] in
            await self?.viewModel.getTweetArray()
        }
    }
    
    private func handleTableviewRefreshActivity() {
        // Reload TableView closure
        viewModel.reloadTableView = { [weak self] in
            Task {[weak self] in
                self?.reloadTableView()
            }
        }
    }
    
    private func handleErrorNotification() {
        // Show network error message
        viewModel.showAPIError = { [weak self] error in
            Task {[weak self] in
                guard let sourceVC = self else {return}
                self?.showApplicationAlert(sourceVC, alertTitle: error.localizedDescription)
            }
        }
    }
    
    @MainActor
    private func reloadTableView() {
        self.tblFeed.reloadData()
    }
    
    @MainActor
    private func showApplicationAlert(_ sourceVC: ProfileViewController, alertTitle: String) {
        Alert.present(title: alertTitle, message: "", actions: .okay(handler: {
        }), from: sourceVC)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweetArray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        if cellVM.isMedia {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaCell.identifier, for: indexPath) as? MediaCell else {
                fatalError(Constants.ErrorMessages.xibNotFound)
            }
            cell.cellViewModel = cellVM
            cell.updateCellProperties(cellViewModel: cellVM)
            return cell
        }else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.identifier, for: indexPath) as? TweetCell else {
                fatalError(Constants.ErrorMessages.xibNotFound)
            }
            cell.cellViewModel = cellVM
            cell.updateCellProperties(cellViewModel: cellVM)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.Value.tableRowEstimatedHeight // estimated height
    }
}

// MARK: - UIScrollView

extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPos: CGFloat = -scrollView.contentOffset.y
        if yPos > 0 {
            var imgRect: CGRect? = tableHeaderView.frame
            imgRect?.origin.y = scrollView.contentOffset.y
            imgRect?.size.height = Constants.Value.SCREEN_WIDTH / 2 + yPos  - Constants.Value.SCREEN_WIDTH / 2
            tableHeaderView.frame = imgRect!
            self.tblFeed.sectionHeaderHeight = (imgRect?.size.height)!
        }
    }
}
