import Foundation

typealias Parameters = [String: String]

struct EndpointURL {
    var scheme: String
    var host: String
    var path: String
    var parameters: Parameters
    
    var stringURL: String?
    var fileURL: String?

    var url: URL? {
        createURL(from: stringURL)
    }
    
    var urlFromPath: URL? {
        URL(fileURLWithPath: fileURL ?? "")
    }
    
    public init(scheme: String = Constants.API.scheme,
                 host: String = Constants.API.host,
                 path: String = String(),
                 parameters: Parameters = [:]
    ) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.parameters = parameters
    }
    
    public init(url: String) {
        self.init()
        self.stringURL = url
    }
    
    public init(fileURL: String) {
        self.init()
        self.fileURL = fileURL
    }
    
    private func createURL(from url: String? = nil) -> URL? {
        
        if let url = url {
            return URL(string: url)
        } else {
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = host
            urlComponents.path = path
            
            if parameters.isNotEmpty {
                urlComponents.queryItems = parameters.map {
                    URLQueryItem(name: $0, value: $1)
                }
            }
            return urlComponents.url
        }
    }
}

