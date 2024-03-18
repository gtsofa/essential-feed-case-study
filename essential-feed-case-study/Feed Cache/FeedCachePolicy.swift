//
//  FeedCachePolicy.swift
//  essential-feed-case-study
//
//  Created by Julius on 14/03/2024.
//

import Foundation

// value object
final class FeedCachePolicy {
    private init() {}
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    // Date type is a struct and it's immutable in this scope
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
