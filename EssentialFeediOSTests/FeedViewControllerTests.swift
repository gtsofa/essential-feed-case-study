//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Julius on 10/04/2024.
//

import XCTest
import UIKit
import essential_feed_case_study
import EssentialFeediOS

final class FeedViewControllerTests: XCTestCase {
    // test load feed actions
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        //load feed behavior
        sut.simulateAppearance() // calls viewDidLoad()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        // trigger the refreshcontrol action which happens on a .valueChanged event
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once a user initiates a load")
        
        // view is loaded only once
        // pull to refresh can be done more than once
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected a third loading request once a user initiates another load")
    }
    
    // test loading indicator
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance() // viewDidLoad
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view appears")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once a user initiates a load")
        loader.completeFeedLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed")
        
    }
    
    func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        // create feed image (location, description, imageURL)
        // we want to render a cell for a given model
        // a create a model
        let image0 = makeImage(description: "a description", location: "a location")
        let image1 = makeImage(description: nil, location: "another location")
        let image2 = makeImage(description: "another description", location: nil)
        let image3 = makeImage(description: nil, location: nil)
        let (sut, loader) = makeSUT()
        //when
        ///  0 case
        sut.simulateAppearance()//loadViewIfNeeded()
        //no images are rendered yet
        XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), 0)
        
        // loader completes loading 1 image
        /// 1 element
        loader.completeFeedLoading(with: [image0], at: 0)
        XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), 1)
        
        // check the tableview was rendered with the proper data
        // feedimageview is a type of uitableviewcell
        let view = sut.feedImageView(at: 0) as? FeedImageCell // view is of FeedImageCell type
        //inspect the attributes of the view
        // should not be nil
        XCTAssertNotNil(view)
        XCTAssertEqual(view?.isShowingLocation, true)//should be showing the location koz we gave it a location. i.e either show/hid location
        XCTAssertEqual(view?.locationText, image0.location)// location text should be same as image location text
        XCTAssertEqual(view?.descriptionText, image0.description)// description text should be same as image description text
        
        // everytime you test collection; test: 1)zero case 2) 1 element case 3)many elements case
        /// many element case
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoading(with: [image0, image1, image2, image3])
        XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), 4) // expect to render 4 images
        
        //check the view was rendered with the proper data for image1
        let view1 = sut.feedImageView(at: 1) as? FeedImageCell // i.e 2nd view which is same as 2nd cell
        //inspect teh view attributes
        XCTAssertNotNil(view1)
        XCTAssertEqual(view1?.isShowingLocation, true)
        XCTAssertEqual(view1?.locationText, image1.location)
        XCTAssertEqual(view1?.descriptionText, image1.description)
        
        //check the view was rendered with the proper data for image2
        let view2 = sut.feedImageView(at: 2) as? FeedImageCell // i.e 2nd view which is same as 2nd cell
        //inspect teh view attributes
        XCTAssertNotNil(view2)
        XCTAssertEqual(view2?.isShowingLocation, false)
        XCTAssertEqual(view2?.locationText, image2.location)
        XCTAssertEqual(view2?.descriptionText, image2.description)
        
        //check the view was rendered with the proper data for image3
        let view3 = sut.feedImageView(at: 3) as? FeedImageCell // i.e 3rd view which is on the 3rd row
        //inspect teh view attributes
        XCTAssertNotNil(view3)
        XCTAssertEqual(view3?.isShowingLocation, false)
        XCTAssertEqual(view3?.locationText, image3.location)
        XCTAssertEqual(view3?.descriptionText, image3.description)
        
        

        // check all the views but test will be longer so move the view inspection into a helper function
        // something like `assertThat(sut, hasViewConfiguredFor: image0, at: 0)` for example
        
    }

    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    
    
    private func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "http://any-url.com")!) -> FeedImage {
        return FeedImage(id: UUID(), description: description, location: location, url: url)
    }
    
    class LoaderSpy: FeedLoader {
        private var completions = [(FeedLoader.Result) -> Void ]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            completions[index](.success(feed))
        }
    }
}

private class FakeRefreshControl: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool { _isRefreshing }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}

//FeedViewController
private extension FeedViewController {
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        return tableView.numberOfRows(inSection: feedImagesSection)
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource// gets data source
        let index = IndexPath(row: row, section: feedImagesSection)// create index path for a given row
        return ds?.tableView(tableView, cellForRowAt: index) // ask for data source for the cell at that index
    }
    
    private var feedImagesSection: Int {
        return 0
    }
    
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            prepareForFirstAppearance()
            //replaceRefreshControlWithFakeForiOS17Support()
        }
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    private func prepareForFirstAppearance() {
        setSmallFrameToPreventRenderingCells()
        replaceRefreshControlWithFakeForiOS17Support()
    }
    
    private func setSmallFrameToPreventRenderingCells() {
        tableView.frame = CGRect(x: 0, y: 0, width: 390, height: 1)
    }
    
    func replaceRefreshControlWithFakeForiOS17Support() {
        let fake = FakeRefreshControl()
        refreshControl?.allTargets.forEach{ target in
            refreshControl?.actions(forTarget: target, forControlEvent:
                    .valueChanged)?.forEach { action in
                        fake.addTarget(target, action: Selector(action), for: .valueChanged)
                    }
        }
        refreshControl = fake
    }
}

private extension FeedImageCell {
    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }
    
    var locationText: String? {
        return locationLabel.text
    }
    
    var descriptionText: String? {
        return descriptionLabel.text
    }
}

private extension UIRefreshControl {
    // Read all of the targets for UIRefreshControl (in our instance there is only one target which is self) and for any defined .valueChanged events perform the selector that was assigned to the target for the event.
    func simulatePullToRefresh() {
        allTargets.forEach{ target in
            actions(forTarget: target, forControlEvent:
                    .valueChanged)?.forEach {
                        (target as NSObject).perform(Selector($0))
                    }
        }
    }
}

