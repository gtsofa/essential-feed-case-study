//
//  EssentialFeedCacheIntegrationTests.swift
//  EssentialFeedCacheIntegrationTests
//
//  Created by Julius on 27/03/2024.
//

import XCTest
import essential_feed_case_study

final class EssentialFeedCacheIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    // MARK: - LocalFeedLoader Tests
    
    func test_loadFeed_deliversNoItemsOnEmptyCache() {
        let feedLoader = makeFeedLoader()
        
        expect(feedLoader, toLoad: [])
    }
    
    func test_loadFeed_deliversItemsSavedOnASeparateInstance() {
        //saving and loading instances...we dont have this in the unit tests (i.e in-memory)
        let feedLoaderToPerformSave = makeFeedLoader()
        let feedLoaderToPerformLoad = makeFeedLoader()
        let feed = uniqueImageFeed().models
        
        save(feed, with: feedLoaderToPerformSave)
        
        expect(feedLoaderToPerformLoad, toLoad: feed)
        
    }
    
    func test_saveFeed_overridesItemsSavedOnASeparateInstances() {
        //make two saves
        let feedLoaderToPerformFirstSave = makeFeedLoader()
        let feedLoaderToPerformLastSave = makeFeedLoader()
        let feedLoaderToPerformLoad = makeFeedLoader()
        let firstFeed = uniqueImageFeed().models
        let lastFeed = uniqueImageFeed().models
        
        save(firstFeed, with: feedLoaderToPerformFirstSave)
        save(lastFeed, with: feedLoaderToPerformLastSave)
        
        expect(feedLoaderToPerformLoad, toLoad: lastFeed)
    }
    
    func test_validateFeedCache_deletesFeedSavedInADistantPast() {
        let feed = uniqueImageFeed().models
        let feedLoaderToPerformSave = makeFeedLoader(currentDate: .distantPast)
        let feedLoaderToPerformValidation = makeFeedLoader(currentDate: Date())
        
        save(feed, with: feedLoaderToPerformSave)
        validateCache(with: feedLoaderToPerformValidation)
        
        expect(feedLoaderToPerformSave, toLoad: [])
    }
    
    // MARK: - LocalFeedImageDataLoader Tests
    
    func test_loadImageData_deliversSavedDataOnASeparateInstance() {
        let feedLoader = makeFeedLoader()
        let image = uniqueImage()
        let imageLoaderToPerformSave = makeImageLoader()
        let imageLoaderToPerformLoad = makeImageLoader()
        let dataToSave = anyData()
        
        
        save([image], with: feedLoader)
        save(dataToSave, for: image.url, with: imageLoaderToPerformSave)
        
        expect(imageLoaderToPerformLoad, toLoad: dataToSave, for: image.url)
    }
    
    func test_saveImageData_overridesSavedimageDataOnASeparateInstance() {
        let imageLoaderToPerfromFirstSave = makeImageLoader()
        let imageLoaderToPerformLastSave = makeImageLoader()
        let imageLoaderToPerformLoad = makeImageLoader()
        let feedLoader = makeFeedLoader()
        let image = uniqueImage()
        let firstImageData = anyData()
        let lastImageData = anyData()
        
        save([image], with: feedLoader)
        save(firstImageData, for: image.url, with: imageLoaderToPerfromFirstSave)
        save(lastImageData, for: image.url, with: imageLoaderToPerformLastSave)
        
        expect(imageLoaderToPerformLoad, toLoad: lastImageData, for: image.url)
    }
    
    
    // MARK: - Helpers
    
    private func makeFeedLoader(currentDate: Date = Date(), file: StaticString = #filePath,
                         line: UInt = #line) -> LocalFeedLoader {
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL)
        let sut = LocalFeedLoader(store: store, currentDate: { currentDate })
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func makeImageLoader(file: StaticString = #filePath, line: UInt = #line) -> LocalFeedImageDataLoader {
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL)
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    // save(feed, with: sutToperformsave)
    private func save(_ feed: [FeedImage], with loader: LocalFeedLoader, file: StaticString = #filePath, line: UInt = #line ) {
        //sync api
        do {
            try loader.save(feed)
        } catch {
            XCTFail("Expected to save feed successfully, got error: \(error) instead", file: file, line: line)
        }
    }
    
    private func save(_ data: Data, for url: URL, with loader: LocalFeedImageDataLoader, file: StaticString = #filePath, line: UInt = #line) {
        do {
            try loader.save(data, for: url)
        } catch {
            XCTFail("Expected to save image data successfully, got error: \(error)", file: file, line: line)
        }
    }
    
    private func validateCache(with loader: LocalFeedLoader, file: StaticString = #file, line: UInt = #line) {
        do {
            try loader.validateCache()
        } catch {
            XCTFail("Expected to validate feed successfully, got error: \(error)", file: file, line: line)
        }
    }
    
    private func expect(_ sut: LocalFeedImageDataLoader, toLoad expectedData: Data, for url: URL, file: StaticString = #filePath, line: UInt = #line) {
        do {
            let loadedData = try sut.loadImageData(from: url)
            XCTAssertEqual(loadedData, expectedData, file: file, line: line)
        } catch {
            XCTFail("Expected successful image data result, got \(error) instead.", file: file, line: line)
        }
    }
    
    // expect(sut, toLoad: [])
    //LocalFeedLoader.load() imple
    private func expect(_ sut: LocalFeedLoader, toLoad expectedFeed: [FeedImage], file: StaticString = #filePath,
                        line: UInt = #line) {
        do {
            let loadedFeed = try  sut.load()
            XCTAssertEqual(loadedFeed, expectedFeed, file: file, line: line)
        } catch {
            XCTFail("Expected successful feed result, got \(error) instead", file: file, line: line)
        }
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
        
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        //return FileManager.default.urls(for: .cachesDirectory, in: .systemDomainMask).first!
    }
    
}
