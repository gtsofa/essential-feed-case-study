//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Julius on 01/05/2024.
//

import UIKit

public final class ErrorView: UIView {
    @IBOutlet public var label: UILabel!
    
    public var message: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        label.text = nil
    }
}
