import Foundation
import RxSwift

protocol HTTPResponse {
    var data: Data { get }
    var statusCode: Int { get }
}

struct HTTPClientResponse: HTTPResponse {
    
    var data: Data
    var statusCode: Int
    
    init(data: Data, statusCode: Int) {
        self.data = data
        self.statusCode = statusCode
    }
}
