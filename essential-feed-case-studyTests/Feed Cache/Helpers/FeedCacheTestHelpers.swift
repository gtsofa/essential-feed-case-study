//
//  FeedCacheTestHelpers.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 13/03/2024.
//

import Foundation
import essential_feed_case_study

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

// map [FeedItem] -> [LocalFeedItem]
func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    // map feeditems to localfeeditems
    let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    
    return (models, local)
}

extension Date {
    // DSL methods
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    // computed var so we call it only on demand
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}
    
extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
