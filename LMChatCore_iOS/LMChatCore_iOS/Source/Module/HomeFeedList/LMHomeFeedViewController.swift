//
//  LMHomeFeedViewController.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/02/24.
//

import Foundation
import LMChatUI_iOS

open class LMHomeFeedViewController: LMViewController {
    
    var viewModel: LMHomeFeedViewModel?
    
    open private(set) lazy var feedListView: LMHomeFeedListView = {
        let view = LMHomeFeedListView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .systemGroupedBackground
        view.delegate = self
        return view
    }()
    
    open private(set) lazy var profileIcon: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.setWidthConstraint(with: 36)
        image.setHeightConstraint(with: 36)
        image.cornerRadius(with: 18)
        return image
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupLayouts()
        
        viewModel?.getChatrooms()
        viewModel?.syncChatroom()
        self.setNavigationTitleAndSubtitle(with: "Community", subtitle: nil, alignment: .center)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let deeplinkUrl = LMSharedPreferences.getString(forKey: .tempDeeplinkUrl) {
            LMSharedPreferences.removeValue(forKey: .tempDeeplinkUrl)
            DeepLinkManager.sharedInstance.routeToScreen(routeUrl: deeplinkUrl, fromNotification: false, fromDeeplink: true)
        }
        profileIcon.kf.setImage(with: URL(string: viewModel?.memberProfile?.imageUrl ?? ""), placeholder: UIImage.generateLetterImage(name: viewModel?.memberProfile?.name ?? ""))
        viewModel?.getExploreTabCount()
    }
    
    // MARK: setupViews
    open override func setupViews() {
        self.view.addSubview(feedListView)
        setupRightItemBars()
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        NSLayoutConstraint.activate([
            feedListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            //            containerView.heightAnchor.constraint(equalToConstant: 40),
            feedListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            feedListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func setupRightItemBars() {
        let profileItem = UIBarButtonItem(customView: profileIcon)
        let searchItem = UIBarButtonItem(image: Constants.shared.images.searchIcon, style: .plain, target: self, action: #selector(searchBarItemClicked))
        searchItem.tintColor = Appearance.shared.colors.textColor
        navigationItem.rightBarButtonItems = [profileItem, searchItem]
    }
    
    @objc func searchBarItemClicked() {
        NavigationScreen.shared.perform(.searchScreen, from: self, params: nil)
    }
}

extension LMHomeFeedViewController: LMHomeFeedViewModelProtocol {
    
    public func updateHomeFeedChatroomsData() {
       let chatrooms =  (viewModel?.chatrooms ?? []).compactMap({ chatroom in
            LMHomeFeedChatroomCell.ContentModel(chatroom: chatroom)
        })
        feedListView.updateChatroomsData(chatroomData: chatrooms)
    }
    
    public func updateHomeFeedExploreCountData() {
        guard let countData = viewModel?.exploreTabCountData else { return }
        feedListView.updateExploreTabCount(exploreTabCount: LMHomeFeedExploreTabCell.ContentModel(totalChatroomsCount: countData.totalChatroomCount, unseenChatroomsCount: countData.unseenChatroomCount))
    }
    
    
    public func reloadData() {
        
    }
}

extension LMHomeFeedViewController: LMHomFeedListViewDelegate {
    
    public func didTapOnCell(indexPath: IndexPath) {
        switch feedListView.tableSections[indexPath.section].sectionType {
        case .exploreTab:
            NavigationScreen.shared.perform(.exploreFeed, from: self, params: nil)
        case .chatrooms:
            guard let viewModel else { return }
            let chatroom = viewModel.chatrooms[indexPath.row]
            NavigationScreen.shared.perform(.chatroom(chatroomId: chatroom.id), from: self, params: nil)
        default:
            break
        }
    }
    
    public func fetchMoreData() {
//     Add Logic for next page data
    }
}
