import Foundation

enum ProductRequest: HTTPRequest {
    case getProducts
    case dowmloadImage(url: String)
    
    var endpointURL: EndpointURL {
        switch self {
        case .getProducts:
            return EndpointURL(path: "/items.json")
        case let .dowmloadImage(url):
            return EndpointURL(url: url)
        }
    }
}
