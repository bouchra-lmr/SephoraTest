import Foundation
import RxSwift
import UIKit

struct ProductsViewModel {
    
    private let productService: ProductService
    private let disposeBag = DisposeBag()
    
    var productsPublisher = PublishSubject<[Product]>()
    var imagePublisher = PublishSubject<UIImage>()

    
    init(productService: ProductService) {
        self.productService = productService
    }
    
    func getAllProduct() {
        productService
            .fetchProducts()
            .map({ products in
                products.sorted { lhs, _ in
                    lhs.isSpecialBrand
                }
            })
            .subscribe { products in
                productsPublisher.onNext(products)
                productsPublisher.onCompleted()
            } onFailure: { error in
                productsPublisher.onError(error)
            }
            .disposed(by: disposeBag)
    }
    
    func downloadImage(from url: String) {
        productService
            .downloadImage(from: url)
            .subscribe { image in
                imagePublisher.onNext(image)
            } onFailure: { error in
                imagePublisher.onError(error)
            }
            .disposed(by: disposeBag)
    }
}
