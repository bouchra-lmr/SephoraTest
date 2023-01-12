import XCTest
@testable import Sephora


class EndpointURLTests: XCTestCase {
    
    var sut: EndpointURL!

    override func setUp() {}

    override func tearDown() {
        sut = nil
    }

    func testCreateURLFromString() {
        // Given
        sut = EndpointURL(url: "https://www.google.com")
        
        // When
        let url = sut.url
        
        // Then
        guard let url = url else {
            XCTFail("Could not create url")
            return
        }

        XCTAssertNotNil(url)
        XCTAssertEqual(url.host, "www.google.com")
    }
    
    func testCreateURLFromComponents() {
        // Given
        sut = EndpointURL(scheme: "https", host: "www.google.com", path: "/images", parameters: [:])
        
        // When
        let url = sut.url
        
        // Then
        guard let url = url else {
            XCTFail("Could not create url")
            return
        }

        XCTAssertNotNil(url)
        XCTAssertEqual(url.absoluteString, "https://www.google.com/images")
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "www.google.com")
        XCTAssertEqual(url.path, "/images")
    }
}
