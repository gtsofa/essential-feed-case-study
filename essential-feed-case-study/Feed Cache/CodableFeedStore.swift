//
//  CodableFeedStore.swift
//  essential-feed-case-study
//
//  Created by Julius on 20/03/2024.
//

import Foundation

public final class CodableFeedStore: FeedStore {
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: Date
        
        var localFeed: [LocalFeedImage] {
            return feed.map { $0.local}
        }
    }
    
    // mirror of localfeedimage to fix the codable conformance issue
    private struct CodableFeedImage: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let url: URL
        
        // map LocalFeedImage -> CodableFeedImage using initializer
        init(_ image: LocalFeedImage) {
            id = image.id
            description = image.description
            location = image.location
            url = image.url
        }
        
        var local: LocalFeedImage {
            return LocalFeedImage(id: id, description: description, location: location, url: url)
        }
    }
    
    private let storeURL: URL
    
   public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        guard FileManager.default.fileExists(atPath: storeURL.path) else {
            return completion(nil)
        }
        // delete only when you do not have deletion error
        do {
            try FileManager.default.removeItem(at: storeURL)
            completion(nil)
            
        } catch {
            completion(error)
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        // retrieve data
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        
        // we have data, so decode/unpack it and
        do {
            // before we decode the data we check if it's valid
            let decoder = JSONDecoder()
            let cache = try decoder.decode(Cache.self, from: data)
            completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
        } catch {
            completion(.failure(error))
        }
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        // a successful insertion has a nil result (i.e has nil error)
        do {
            let encoder = JSONEncoder()
            // we can map the feed with codablefeedimage
            let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
            // check url is valid before writing content to it
            let encoded = try encoder.encode(cache)
            // write this data to disk
            try encoded.write(to: storeURL)
            // let insert and complete with nil error
            completion(nil)
        } catch {
            // let insert and complete with error
            completion(error)
        }
        
    }
}
