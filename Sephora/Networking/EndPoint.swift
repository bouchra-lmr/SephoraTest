import Foundation

struct EndpointURL {
    var scheme: String
    var host: String
    var path: String
    var endpointURL: URL
    
    public init?(scheme: String = Constants.API.scheme,
                host: String = Constants.API.host,
                path: String = String()
    ) {
       
        self.scheme = scheme
        self.host = host
        self.path = path
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path

        guard let url = urlComponents.url else {
            return nil
        }
        
        endpointURL = url
    }
}
