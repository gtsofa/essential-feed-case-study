//
//  ImageCommentsSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by Julius on 01/07/2024.
//

import XCTest
import EssentialFeediOS
@testable import essential_feed_case_study

final class ImageCommentsSnapshotTests: XCTestCase {
    func test_listWithComments() {
        let sut = makeSUT()
        
        sut.display(comments())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "IMAGE_COMMENTS_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "IMAGE_COMMENTS_dark")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSize: .extraExtraExtraLarge)), named: "IMAGE_COMMENTS_light_extraExtraExtraLarge")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.simulateAppearance()
        return controller
    }
    
    private func comments() -> [CellController] {
        commentControllers().map { CellController(id: UUID(), $0) }
    }
    
    private func commentControllers() -> [ImageCommentCellController] {
        return [
            ImageCommentCellController(
                model: ImageCommentViewModel(
                    message: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.",
                    date: "1000 years ago",
                    username: "a very long long long long username"
                )
            ),
                ImageCommentCellController(
                    model: ImageCommentViewModel(
                        message: "Garth Pier is a Grade II listed structure in Bangor, Gwynedd, North Wales.",
                        date: "10 days ago",
                        username: "a username"
                    )
                ),
                    ImageCommentCellController(
                        model: ImageCommentViewModel(
                            message: "nice",
                            date: "1 minute ago",
                            username: "a."
                        )
                    )
        ]
    }
}
