import Foundation

typealias HTTPHeaders = [String: String]
typealias HTTPBody = [String: Any]

protocol HTTPRequest {
    var endpointURL: EndpointURL { get }
    var httpMethod: HTTPMethod { get }
    var httpHeaders: HTTPHeaders { get }
    var body: HTTPBody { get }
    
    func create() throws -> URLRequest
}

extension HTTPRequest {
    var httpMethod: HTTPMethod {
        .get
    }
    
    var httpHeaders: HTTPHeaders {
        [:]
    }
    
    var body: HTTPBody {
        [:]
    }
    
    func create() throws -> URLRequest {
        guard let url = endpointURL.url else { throw HTTPError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.setValue(Constants.MIME.json, forHTTPHeaderField: Constants.MIME.content)
        if httpHeaders.isNotEmpty {
            urlRequest.allHTTPHeaderFields = httpHeaders
        }
        if body.isNotEmpty {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return urlRequest
    }
}
