//
//  FeedViewController.swift
//  Prototype
//
//  Created by Julius on 01/04/2024.
//

import UIKit

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let imageName: String // url from api:)
}

class FeedViewController: UITableViewController {
    private var feed = [FeedImageViewModel]()
    
    private var viewAppeared = false
    
    override func viewIsAppearing(_ animated: Bool) {
        if !viewAppeared {
            refresh()
            tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: false)
            viewAppeared = true
        }
        
    }
    
    @IBAction func refresh() {
        refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.feed.isEmpty {
                self.feed = FeedImageViewModel.prototypeFeed
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feed.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath) as! FeedImageCell
        
        let model = feed[indexPath.row]
        cell.configure(with: model)

        // Configure the cell...

        return cell
    }

}

extension FeedImageCell {
    func configure(with model: FeedImageViewModel) {
        locationLabel.text = model.location
        locationContainer.isHidden = model.location == nil
        
        descriptionLabel.text = model.description
        descriptionLabel.isHidden = model.description == nil
        
        fade(UIImage(named: model.imageName))
        //feedImageView.image = UIImage(named: model.imageName)
    }
}
