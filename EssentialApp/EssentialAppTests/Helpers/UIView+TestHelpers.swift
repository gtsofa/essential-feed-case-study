//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Julius on 27/05/2024.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
