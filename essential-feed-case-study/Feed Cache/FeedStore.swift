//
//  FeedStore.swift
//  essential-feed-case-study
//
//  Created by Julius on 07/03/2024.
//

import Foundation

// a helper class representing the framework side
// to help us define the abstract interface teh use case needs for
// its collaborator
//making sure we don't leak framework details into the use case
// turned into a protocol at the end
public protocol FeedStore {
    // use typealias for readability
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}

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
