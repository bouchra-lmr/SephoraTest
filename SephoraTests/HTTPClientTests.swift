import XCTest
import RxSwift
@testable import Sephora

fileprivate struct HTTPResponseMock: HTTPResponse {
    var data: Data {
        Data()
    }
    
    var statusCode: Int {
        200
    }
}

fileprivate struct HTTPClientMock: HTTPClient {
    func perform(request: HTTPRequest) -> Observable<HTTPResponse> {
        return Observable.just(HTTPResponseMock())
    }
}

class HTTPClientTests: XCTestCase {
    
    private var sut: HTTPClientMock!
    private var disposeBag: DisposeBag!

    override func setUp() {
        sut = HTTPClientMock()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        disposeBag = nil
    }

    func testPerformRequestSuccessfully() throws {
        let expectation = XCTestExpectation(description: "Sould perform request successfully")
        
        sut
            .perform(request: HTTPRequestMock())
            .subscribe { response in
                expectation.fulfill()
                XCTAssertEqual(response.statusCode, 200)
                XCTAssertEqual(response.data.count, 0)
            } onError: { error in
                XCTFail("\(error)")
            }
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 2)
    }
}
