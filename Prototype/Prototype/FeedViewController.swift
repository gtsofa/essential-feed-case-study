//
//  FeedViewController.swift
//  Prototype
//
//  Created by Julius on 01/04/2024.
//

import UIKit

class FeedViewController: UITableViewController {

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath)

        // Configure the cell...

        return cell
    }

}
