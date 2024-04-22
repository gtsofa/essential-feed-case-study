//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Julius on 22/04/2024.
//

import UIKit
import essential_feed_case_study

// feed ui refresh control creation & usage
public final class FeedRefreshViewController: NSObject {
    public lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let feedLoader: FeedLoader?
    
    init(feedLoader: FeedLoader? = nil) {
        self.feedLoader = feedLoader
    }
    
    //var tableModel: [FeedImage]var tableModel: [FeedImage]
    var onRefresh: (([FeedImage]) -> Void)?
    @objc func refresh() {
        view.beginRefreshing()
        feedLoader?.load { [weak self] result in
            if let feed = try? result.get() {
                //set tablemodel//var tableModel: [FeedImage]
                self?.onRefresh?(feed) //(try? result.get()) ?? []
                //reload table view
                //self?.tableView.reloadData()
            }
            self?.view.endRefreshing()
        }
    }
    
}
