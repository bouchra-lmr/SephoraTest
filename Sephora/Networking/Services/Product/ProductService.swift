import Foundation
import RxSwift
import RxCocoa
import UIKit

struct ProductService {
   
    let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
}

extension ProductService {
    func fetchProducts() -> Single<[Product]> {
        return service
            .getResource(request: ProductRequest.getProducts)
    }
}

extension ProductService {
    func downloadImage(from url: String) -> Single<UIImage> {
        return service
            .downloadImageFrom(url: url)
    }
}
