//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Julius on 12/04/2024.
//

import UIKit
import essential_feed_case_study

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL)
}

final public class FeedViewController: UITableViewController {
    private var feedLoader: FeedLoader?
    private var imageLoader: FeedImageDataLoader?
    private var isViewAppeared = false
    private var onViewIsAppearing: ((FeedViewController) -> Void)?
    private var tableModel = [FeedImage]()
    
    public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.init()
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        
        onViewIsAppearing = { vc in
            vc.onViewIsAppearing = nil
            vc.load()
        }
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        onViewIsAppearing?(self)
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        feedLoader?.load { [weak self] result in
            if let feed = try? result.get() {
                //set tablemodel
                self?.tableModel = feed //(try? result.get()) ?? []
                //reload table view
                self?.tableView.reloadData()
            }
            self?.refreshControl?.endRefreshing()
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row] // create a cell model
        let cell = FeedImageCell() // create a cell
        //configure the cell with the model
        cell.locationContainer.isHidden = (cellModel.location == nil) // location container is hidden when data.location==nil
        cell.locationLabel.text = cellModel.location// location text is data.location
        cell.descriptionLabel.text = cellModel.description // location text is data.description
        imageLoader?.loadImageData(from: cellModel.url)
        return cell
    }
}
