//
//  LocalFeedItem.swift
//  essential-feed-case-study
//
//  Created by Julius on 08/03/2024.
//

import Foundation

// DTO
// to remove strong coupling between modules
public struct LocalFeedImage: Equatable, Codable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    public init(id: UUID, description: String?, location: String?, url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}
