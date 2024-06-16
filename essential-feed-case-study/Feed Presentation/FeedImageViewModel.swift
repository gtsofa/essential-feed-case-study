//
//  FeedImageViewModel.swift
//  essential-feed-case-study
//
//  Created by Julius on 05/05/2024.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}
