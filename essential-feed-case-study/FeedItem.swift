//
//  FeedItem.swift
//  essential-feed-case-study
//
//  Created by Julius on 30/01/2024.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL 
}
