//
//  DropboxServiceTests.swift
//  TestDropboxTests
//
//  Created by Yarik on 04.09.2023.
//

import XCTest
import TestDropbox

final class DropboxServiceTests: XCTestCase {
    
    var dropboxService: DropboxService!
    
    override func setUp() {
        super.setUp()
        dropboxService = DropboxService()
    }
    
    override func tearDown() {
        dropboxService = nil
        super.tearDown()
    }
    
    func testDownloadImage() {
        let expectation = XCTestExpectation(description: "Image downloaded")
        
        dropboxService.downloadFile(filename: "test_image.jpeg") { image, _ in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testDownloadVideo() {
        let expectation = XCTestExpectation(description: "Video downloaded")
        
        dropboxService.downloadFile(filename: "test_video.mp4") { _, videoURL in
            XCTAssertNotNil(videoURL)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testDownloadThumbnail() {
        let expectation = XCTestExpectation(description: "Thumbnail downloaded")
        
        dropboxService.downloadThumbnail(filename: "test_image.jpeg") { image in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
