//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Julius on 19/04/2024.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}