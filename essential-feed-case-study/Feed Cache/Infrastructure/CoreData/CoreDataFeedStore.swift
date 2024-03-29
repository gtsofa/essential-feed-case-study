//
//  CoreDataFeedStore.swift
//  essential-feed-case-study
//
//  Created by Julius on 25/03/2024.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()// for tests i guess
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in 
            completion(Result {
                try ManagedCache.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    public func insert(_ feed: [essential_feed_case_study.LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result {
                // create a contex
                //save the context
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                
                // try to save context
                try context.save()
            })
        }
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result(catching: {
                try ManagedCache.find(in: context).map { cache in
                    return CachedFeed(
                        feed: cache.localFeed, timestamp: cache.timestamp)
                }
            }))
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform {
            action(context)
        }
    }
}
