//
//  LMChatDMFeedViewController.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 17/06/24.
//

import Foundation
import LikeMindsChatUI

open class LMChatDMFeedViewController: LMViewController {
    
    var viewModel: LMChatDMFeedViewModel?
    
    open private(set) lazy var feedListView: LMChatHomeFeedListView = {
        let view = LMChatHomeFeedListView().translatesAutoresizingMaskIntoConstraints()
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
    
    open var fabButtonTitle = "NEW DM"
    fileprivate var lastKnowScrollViewContentOfsset: CGFloat = 0
    open var fabButtonWidthConstraints: NSLayoutConstraint?
    
    open private(set) lazy var newDMFabButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.newDMIcon, for: .normal)
        button.setTitle(fabButtonTitle, for: .normal)
        button.titleLabel?.font = Appearance.shared.fonts.textFont2
        button.tintColor = .white
        button.backgroundColor = Appearance.shared.colors.linkColor
        return button
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupLayouts()
        self.setNavigationTitleAndSubtitle(with: "Community", subtitle: nil, alignment: .center)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let deeplinkUrl = LMSharedPreferences.getString(forKey: .tempDeeplinkUrl) {
            LMSharedPreferences.removeValue(forKey: .tempDeeplinkUrl)
            DeepLinkManager.sharedInstance.routeToScreen(routeUrl: deeplinkUrl, fromNotification: false, fromDeeplink: true)
        }
        viewModel?.getChatrooms()
        viewModel?.syncChatroom()
        viewModel?.checkDMStatus()
        profileIcon.kf.setImage(with: URL(string: viewModel?.memberProfile?.imageUrl ?? ""), placeholder: UIImage.generateLetterImage(name: viewModel?.memberProfile?.name?.components(separatedBy: " ").first ?? ""))
    }
    
    // MARK: setupViews
    open override func setupViews() {
        self.view.addSubview(feedListView)
        self.view.addSubview(newDMFabButton)
        setupRightItemBars()
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        NSLayoutConstraint.activate([
            feedListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            feedListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            newDMFabButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            newDMFabButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            newDMFabButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        setupNewFabButton()
    }
    
    open func setupRightItemBars() {
        let profileItem = UIBarButtonItem(customView: profileIcon)
        let searchItem = UIBarButtonItem(image: Constants.shared.images.searchIcon, style: .plain, target: self, action: #selector(searchBarItemClicked))
        searchItem.tintColor = Appearance.shared.colors.textColor
        navigationItem.rightBarButtonItems = [profileItem, searchItem]
    }
    
    open func setupNewFabButton() {
        fabButtonWidthConstraints = newDMFabButton.widthAnchor.constraint(equalToConstant: 120)
        fabButtonWidthConstraints?.isActive = true
        newDMFabButton.setInsets(forContentPadding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), imageTitlePadding: 10)
        newDMFabButton.layer.cornerRadius = 25
        newDMFabButton.addTarget(self, action: #selector(newFabButtonClicked), for: .touchUpInside)
        newDMFabButton.isHidden = true
    }
    
    @objc open func newFabButtonClicked() {
        NavigationScreen.shared.perform(.dmMemberList(showList: viewModel?.showList), from: self, params: nil)
    }
    
    open func newDMButtonExapndAndCollapes(_ offsetY: CGFloat) {
        if offsetY > self.lastKnowScrollViewContentOfsset {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration:0.2) { [weak self] in
                guard let weakSelf = self else {return}
                weakSelf.newDMFabButton.setTitle(nil, for: .normal)
                weakSelf.newDMFabButton.setInsets(forContentPadding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), imageTitlePadding: 0)
                self?.fabButtonWidthConstraints?.isActive = false
                self?.fabButtonWidthConstraints = self?.newDMFabButton.widthAnchor.constraint(equalToConstant: 50.0)
                self?.fabButtonWidthConstraints?.isActive = true
                weakSelf.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let weakSelf = self else {return}
                weakSelf.newDMFabButton.setTitle(weakSelf.fabButtonTitle, for: .normal)
                weakSelf.newDMFabButton.setInsets(forContentPadding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), imageTitlePadding: 10)
                self?.fabButtonWidthConstraints?.isActive = false
                self?.fabButtonWidthConstraints = self?.newDMFabButton.widthAnchor.constraint(equalToConstant: 120.0)
                self?.fabButtonWidthConstraints?.isActive = true
                weakSelf.view.layoutIfNeeded()
            }
        }
    }
    
    open func showDMFabButton(showFab: Bool) {
        newDMFabButton.isHidden = !showFab
    }
    
    @objc open func searchBarItemClicked() {
        NavigationScreen.shared.perform(.searchScreen, from: self, params: nil)
    }
}

extension LMChatDMFeedViewController: LMChatDMFeedViewModelProtocol {
    
    public func checkDMStatus(showDM: Bool) {
        showDMFabButton(showFab: showDM)
    }
    
    public func updateHomeFeedChatroomsData() {
        let chatrooms =  (viewModel?.chatrooms ?? []).compactMap({ chatroom in
            LMChatHomeFeedChatroomCell.ContentModel(contentView: viewModel?.chatroomContentView(chatroom: chatroom))
        })
        feedListView.updateChatroomsData(chatroomData: chatrooms)
    }
    
    public func updateHomeFeedExploreCountData() {
        guard let countData = viewModel?.exploreTabCountData else { return }
        feedListView.updateExploreTabCount(exploreTabCount: LMChatHomeFeedExploreTabCell.ContentModel(totalChatroomsCount: countData.totalChatroomCount, unseenChatroomsCount: countData.unseenChatroomCount))
    }
    
    
    public func reloadData() {}
}

extension LMChatDMFeedViewController: LMHomFeedListViewDelegate {
    
    public func didTapOnCell(indexPath: IndexPath) {
        switch feedListView.tableSections[indexPath.section].sectionType {
        case .chatrooms:
            guard let viewModel else { return }
            let chatroom = viewModel.chatrooms[indexPath.row]
            NavigationScreen.shared.perform(.chatroom(chatroomId: chatroom.id), from: self, params: nil)
        default:
            break
        }
    }
    
    public func fetchMoreData() {
        
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.lastKnowScrollViewContentOfsset = scrollView.contentOffset.y
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        newDMButtonExapndAndCollapes(offsetY)
    }
}