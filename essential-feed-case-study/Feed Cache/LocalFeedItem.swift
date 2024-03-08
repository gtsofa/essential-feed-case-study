//
//  LocalFeedItem.swift
//  essential-feed-case-study
//
//  Created by Julius on 08/03/2024.
//

import Foundation

// DTO
// to remove strong coupling between modules
public struct LocalFeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
