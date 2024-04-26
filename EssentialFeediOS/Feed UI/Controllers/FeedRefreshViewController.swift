//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Julius on 22/04/2024.
//

import UIKit

protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}

// feed ui refresh control creation & usage
public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    public lazy var view = loadView()
    
    private let delegate: FeedRefreshViewControllerDelegate
    
    init(delegate: FeedRefreshViewControllerDelegate) {
        self.delegate = delegate
    }
    
    @objc func refresh() {
        delegate.didRequestFeedRefresh()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
