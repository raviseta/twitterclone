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
    @IBOutlet weak var searchButtonView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameHeaderLabel: UILabel!
    @IBOutlet weak var totalTweetLabel: UILabel!
    @IBOutlet weak var nameTweetHeaderView: UIView!
    @IBOutlet weak var nameTweetViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var navHeaderViewHeightConstraint: NSLayoutConstraint!
    
    var refreshView: UIView!
    var refreshControl = UIRefreshControl()
    
    private var nameTweetViewHeight: CGFloat {
        return nameTweetHeaderView.frame.size.height
    }
    
    private lazy var viewModel: ProfileViewModelProtocol = {
        ProfileViewModel(tweetDataService: TweetDataService(withNetworkManager: NetworkManager()))
    }() as ProfileViewModelProtocol
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
    }
    
    private func configureView() {
        setTableViewProperties()
        searchButtonView.clipsToBounds = true
        searchButtonView.layer.cornerRadius = searchButtonView.frame.size.height / 2
        navHeaderViewHeightConstraint.constant = UIDevice.current.hasNotch ? 92.0 : 64.0
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
        nameTweetViewBottomConstraint.constant = -nameTweetViewHeight
        refreshView = UIView(frame: CGRect(x: 0, y: -(Constants.Value.SCREEN_WIDTH / 2), width: 0, height: 0))
        tblFeed.addSubview(refreshView)
        
        refreshControl.addTarget(self, action: #selector(self.refreshFeed), for: .valueChanged)
        refreshView.addSubview(refreshControl)
        refreshControl.tintColor = .white
    }
    
    @objc
    private func refreshFeed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func configureViewModel() {
        fetchTweets()
        // All callbacks from view models
        handleTableviewRefreshActivity()
        handleErrorNotification()
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
    
    // MARK: UI update operations done using Mainactor on main thread
    
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
        if yPos <= 46.0 {
            if yPos <= 0 {
                self.nameTweetViewBottomConstraint.constant = 0
            } else {
                self.nameTweetViewBottomConstraint.constant = -(yPos / 1.2)
            }
        } else {
            self.nameTweetViewBottomConstraint.constant = -nameTweetViewHeight
        }
        
        if yPos > 0 {
            var headerViewRect: CGRect? = tableHeaderView.frame
            headerViewRect?.origin.y = scrollView.contentOffset.y
            headerViewRect?.size.height = Constants.Value.SCREEN_WIDTH / 2 + yPos  - Constants.Value.SCREEN_WIDTH / 2
            tableHeaderView.frame = headerViewRect!
            self.tblFeed.sectionHeaderHeight = (headerViewRect?.size.height)!
        }
    }
}
