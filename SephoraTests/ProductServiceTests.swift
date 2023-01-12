import XCTest
import RxSwift
@testable import Sephora

fileprivate enum ProductRequestMock: HTTPRequest {
    case getAllProduct
    
    var endpointURL: EndpointURL {
        guard let fileURL = Bundle.main.path(forResource: "sephora", ofType: "json") else {
            fatalError("Could not find Sephora file")
        }
        
        return EndpointURL(fileURL: fileURL)
    }
}

fileprivate struct HTTPClientMock: HTTPClient {
    func perform(request: HTTPRequest) -> Observable<HTTPResponse> {
        
        guard let url = request.endpointURL.urlFromPath, let data = try? Data(contentsOf: url, options: .mappedIfSafe) else {
            return Observable.error(HTTPError.invalidURL)
        }
        
        return Observable.just(HTTPClientResponse(data: data, statusCode: 200))
    }
}

fileprivate struct ProductServiceMock {
    
    let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
}

extension ProductServiceMock {
    func fetchProducts() -> Single<[Product]> {
        return service
            .getResource(request: ProductRequestMock.getAllProduct)
    }
}

class ProductServiceTests: XCTestCase {

    private var sut: ProductServiceMock!
    private var disposeBag: DisposeBag!

    override func setUp() {
        let client = HTTPClientMock()
        let service = Service(client: client)
        sut = ProductServiceMock(service: service)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        disposeBag = nil
    }
    
    func testGetAllProduct_FromJsonFile() throws {
        let expectation = XCTestExpectation(description: "Should perform request successfully")
        
        sut
            .fetchProducts()
            .subscribe { products in
                expectation.fulfill()
                XCTAssertEqual(products.count, 2)
                XCTAssertEqual(products.first?.price, 140.00)
                XCTAssertEqual(products.first?.productName, "Size Up - Mascara Volume Extra Large Immédiat")
            } onFailure: { error in
                XCTFail("\(error)")
            }
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 2)
    }
}
