//
//  FullScreenImageViewModelTestCases.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/27/20.
//

import XCTest
@testable import iOSTestDeviget

class FullScreenImageViewModelTestCases: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_expectedButtonTitle() {
        let viewModel = FullScreenImageViewModel(imageURL: nil)
        XCTAssertEqual(viewModel.saveButtonTitle, "Save Image")
    }
    
    func test_imageURLNotNil_whenCorrectlyInitialized() {
        let viewModel = FullScreenImageViewModel(imageURL: URL(string: "www.reddit.com"))
        XCTAssertNotNil(viewModel.imageURL)
    }
}
