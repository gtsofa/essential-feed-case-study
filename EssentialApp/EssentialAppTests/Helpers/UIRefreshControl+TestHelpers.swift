//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Julius on 19/04/2024.
//

import UIKit

extension UIRefreshControl {
    // Read all of the targets for UIRefreshControl (in our instance there is only one target which is self) and for any defined .valueChanged events perform the selector that was assigned to the target for the event.
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
