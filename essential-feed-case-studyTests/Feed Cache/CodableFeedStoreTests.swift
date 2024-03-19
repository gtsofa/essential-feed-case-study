//
//  CodableFeedStoreTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 18/03/2024.
//

import XCTest
import essential_feed_case_study

final class CodableFeedStore {
    typealias RetrievalCompletion = (RetrieveCachedFeedResult) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
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
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
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
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        // a successful insertion has a nil result (i.e has nil error)
        // let insert and complete with nil error
        let encoder = JSONEncoder()
        // we can map the feed with codablefeedimage
        let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
        let encoded = try! encoder.encode(cache)
        // write this data to disk
        try! encoded.write(to: storeURL)
        completion(nil)
    }
}


final class CodableFeedStoreTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }
    
    override func setUp() {
        super.setUp()
        setupEmptyStoreState()
        
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
    
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieveTwice_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        let sut = makeSUT()
        
        //insert
        insert((feed, timestamp), to: sut)
        
        //retrieve
        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp))
        
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        //insert something in cache
        // retrieve twice
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timestamp))
    }
    
    func test_retrieve_dleiversFailureOnRetrievalError() {
        //insert something
        //try to retrieve it and get an error
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        // try to insert invalid data to a URL
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        // retrieve
        expect(sut, toRetrieve: .failure(anyNSError()))
        
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        //insert something
        //try to retrieve it and get an error
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        // try to insert invalid data to a URL
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        // retrieve twice does not delete the invalid data
        // that's not the job for the codableFeedstore
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
        
    }
    
    // MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil,  file: StaticString = #filePath,
                         line: UInt = #line) -> CodableFeedStore {
        
        let sut = CodableFeedStore(storeURL: testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: CodableFeedStore) {
        let exp = expectation(description: "Wait for cache insertion completion")
        sut.insert(cache.feed, timestamp: cache.timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: CodableFeedStore, toRetrieveTwice expectedResult: RetrieveCachedFeedResult, file: StaticString = #filePath,
                        line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: CodableFeedStore, toRetrieve expectedResult: RetrieveCachedFeedResult, file: StaticString = #filePath,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for retrieve completion")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty),
                (.failure, .failure):
                
                break
                
            case let (.found(expectedFeed, expectedTimestamp), .found(retrievedFeed, retrievedTimestamp)):
                XCTAssertEqual(retrievedFeed, expectedFeed, file: file, line: line)
                XCTAssertEqual(retrievedTimestamp, expectedTimestamp, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
        
    }
}
