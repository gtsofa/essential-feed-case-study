//
//  FeedEndpoint.swift
//  essential-feed-case-study
//
//  Created by Julius on 06/07/2024.
//

import Foundation

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("v1/feed")
        }
    }
}
