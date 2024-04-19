//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Julius on 19/04/2024.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach{ target in
            actions(forTarget: target, forControlEvent:
                    .touchUpInside)?.forEach {
                        (target as NSObject).perform(Selector($0))
                    }
        }
    }
}
