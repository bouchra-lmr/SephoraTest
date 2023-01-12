import UIKit
import RxSwift

protocol ServiceProtocol {
    var client: HTTPClient { get }
    
    func getResource<Resource: Decodable>(request: HTTPRequest) -> Single<Resource>
    func downloadImageFrom(url: String) -> Single<UIImage>
}

struct Service: ServiceProtocol {
    var client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func getResource<Resource: Decodable>(request: HTTPRequest) -> Single<Resource> {
        client
            .perform(request: request)
            .map { response -> Data in
                guard response.statusCode == 200  else {
                    throw HTTPError.serverError
                }
                return response.data
            }
            .decode(type: Resource.self, decoder: JSONDecoder())
            .catch { error -> Observable<Resource> in
                return Observable.error(HTTPError.decodingError)
            }
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
    
    func downloadImageFrom(url: String) -> Single<UIImage> {
        client
            .perform(request: ProductRequest.dowmloadImage(url: url))
            .map { response -> UIImage in
                guard response.statusCode == 200  else {
                    throw HTTPError.serverError
                }

                guard let image = UIImage(data: response.data) else {
                    throw HTTPError.decodingError
                }

                return image
            }
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
}
