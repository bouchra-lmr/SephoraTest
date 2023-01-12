import XCTest
@testable import Sephora

struct HTTPRequestMock: HTTPRequest {
    
    var endpointURL: EndpointURL {
        return EndpointURL()
    }
    
    var httpMethod: HTTPMethod {
        .post
    }
}

class HTTPRequestTests: XCTestCase {
    
    var sut: HTTPRequest!

    override func setUp() {
        sut = HTTPRequestMock()
    }

    override func tearDown() {
        sut = nil
    }

    func testCreateHttpRequest() {
        
        guard let request = try? sut.create() else {
            XCTFail("Cannot create request")
            return
        }
        
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
}
