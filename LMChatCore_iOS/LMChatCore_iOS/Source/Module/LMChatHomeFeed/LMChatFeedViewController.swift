//
//  LMChatFeedViewController.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 14/06/24.
//

import Foundation
import LikeMindsChatUI

open class LMChatFeedViewController: LMViewController {
    
    var viewModel: LMChatFeedViewModel?
    
    open private(set) lazy var containerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 16
        return view
    }()
    
    open private(set) lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.setHeightConstraint(with: 40)
        segment.insertSegment(withTitle: "Group", at: 0, animated: true)
        segment.insertSegment(withTitle: "DM", at: 1, animated: true)
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    open private(set) lazy var pageContainerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    private lazy var pageController: UIPageViewController = {
        let pg = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pg
    }()
    
    private var viewControllers: [UIViewController] = []
    private var currentPageIndex = 0 {
        didSet {
            segmentControl.selectedSegmentIndex = currentPageIndex
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        pageController.setViewControllers([viewControllers[currentPageIndex]], direction: .forward, animated: false) { _ in }
    }
    
    open override func setupViews() {
        super.setupViews()
        self.view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(segmentControl)
        containerStackView.addArrangedSubview(pageContainerView)
        setupSegmentControl()
        addControllers()
        setupPageController()
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        self.view.safeAreaPinSubView(subView: containerStackView, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        segmentControl.addConstraint(leading: (containerStackView.leadingAnchor, 16),
        trailing: (containerStackView.trailingAnchor, -16))
        pageContainerView.addConstraint(leading: (containerStackView.leadingAnchor, 0),
                                     trailing: (containerStackView.trailingAnchor, 0))
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
    }
    
    open override func setupActions() {
        super.setupActions()
    }
    
    private func setupSegmentControl() {
        let font: UIFont = Appearance.shared.fonts.headingFont1
        
        let textAttributes: [NSAttributedString.Key : AnyObject] = [
            .foregroundColor: Appearance.shared.colors.black,
            .font: font
        ]
        segmentControl.setTitleTextAttributes(textAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(textAttributes, for: .highlighted)
        segmentControl.setTitleTextAttributes(textAttributes, for: .selected)
        segmentControl.isHidden = false
    }
    
    private func setupPageController() {
        pageController.dataSource = self
        pageController.delegate = self
        
        addChild(pageController)
        pageContainerView.addSubview(pageController.view)
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageController.view.topAnchor.constraint(equalTo: pageContainerView.topAnchor, constant: 0.0),
            pageController.view.bottomAnchor.constraint(equalTo: pageContainerView.bottomAnchor, constant: 0.0),
            pageController.view.leadingAnchor.constraint(equalTo: pageContainerView.leadingAnchor, constant: 0.0),
            pageController.view.trailingAnchor.constraint(equalTo: pageContainerView.trailingAnchor, constant: 0.0),
        ])
        
        pageController.didMove(toParent: self)
    }
    
    open func addControllers() {
        guard let homefeedvc = try? LMChatHomeFeedViewModel.createModule() else { return }
        viewControllers.append(homefeedvc)
        
        guard let homefeedvc2 = try? LMChatHomeFeedViewModel.createModule() else { return }
        viewControllers.append(homefeedvc2)
    }

    
    @objc open func segmentChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        if (currentPageIndex < index) {
            pageController.setViewControllers([self.viewControllers[index]], direction: .forward, animated: true) { _ in }
        } else {
            pageController.setViewControllers([self.viewControllers[index]], direction: .reverse, animated: true) { _ in }
        }
        currentPageIndex = index
        segmentControl.isEnabled = true
    }
}

extension LMChatFeedViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.firstIndex(of: viewController),
           index < viewControllers.count - 1 {
            return viewControllers[index + 1]
        }
        return nil
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.firstIndex(of: viewController), index > 0 {
            return viewControllers[index - 1]
        }
        return nil
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,  previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        segmentControl.isEnabled = true
        self.tabBarController?.tabBar.isHidden = false
        guard completed else { return }
        if let toFind = pageViewController.viewControllers?.first,
           let currIndex = viewControllers.firstIndex(of: toFind) {
            currentPageIndex = currIndex
        }
    }
}

extension LMChatFeedViewController: LMChatFeedViewModelProtocol {
    
}
