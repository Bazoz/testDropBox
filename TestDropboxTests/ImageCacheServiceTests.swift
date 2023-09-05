//
//  ImageCacheServiceTests.swift
//  TestDropboxTests
//
//  Created by Yarik on 04.09.2023.
//

import XCTest
import TestDropbox

final class ImageCacheServiceTests: XCTestCase {
    
    var imageCacheService: ImageCacheService!
    
    override func setUp() {
        super.setUp()
        imageCacheService = ImageCacheService.shared
    }
    
    override func tearDown() {
        imageCacheService = nil
        super.tearDown()
    }
    
    func testSaveFullImage() {
        let imageName = "test_image.jpg"
        let image = UIImage(named: imageName)
        
        imageCacheService.saveFullImage(filename: imageName, image: image)
        
        XCTAssertNotNil(imageCacheService.getCachedFullImage(for: imageName))
    }
    
    func testSaveThumbnail() {
        let imageName = "test_image.jpg"
        let image = UIImage(named: imageName)!
        
        imageCacheService.saveThumbnail(filename: imageName, image: image)
        
        XCTAssertNotNil(imageCacheService.getCachedThumbnail(for: imageName))
    }
    
    func testDeleteFile() {
        let imageName = "test_image.jpg"
        
        let imageData = UIImage(named: imageName)
        
        imageCacheService.saveFullImage(filename: imageName, image: imageData)
        
        XCTAssertNotNil(imageCacheService.getCachedFullImage(for: imageName))
        
        guard let fileURL = imageCacheService.getCachedFullImageURL(for: imageName) else {
            XCTFail("Failed to get file URL")
            return
        }
        
        imageCacheService.deleteFile(at: fileURL)
        
        XCTAssertNil(imageCacheService.getCachedFullImage(for: imageName))
    }

}

