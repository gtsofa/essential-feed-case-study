//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Julius on 01/07/2024.
//

import UIKit
import essential_feed_case_study

public class ImageCommentCellController: NSObject, UITableViewDataSource {
    
    private let model: ImageCommentViewModel
    
    public init(model: ImageCommentViewModel) {
        self.model = model
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.usernameLabel.text = model.username
        cell.messageLabel.text = model.message
        cell.dateLabel.text = model.date
        return cell
    }
}
