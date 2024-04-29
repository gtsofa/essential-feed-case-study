//
//  UITableView+dequeueing.swift
//  EssentialFeediOS
//
//  Created by Julius on 29/04/2024.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T:UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
