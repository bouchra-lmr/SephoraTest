import UIKit
import RxSwift
import RxCocoa

class ProductsViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    var viewModel: ProductsViewModel
    private let disposeBag = DisposeBag()
    
    init(client: HTTPClient) {
        let productService = ProductService(service: Service(client: client))
        self.viewModel = ProductsViewModel(productService: productService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        setupBinding()
        viewModel.getAllProduct()
    }

    private func setupCollectionView() {
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.id)
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = Constants.title

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.Dimension.horizontalInset / 2
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - Constants.Dimension.horizontalInset,
                                 height: Constants.Dimension.cellHeight
        )
        return layout
    }
    
    let products = [Product]()
    
    private func setupBinding() {
        viewModel
            .productsPublisher
            .bind(to: collectionView
                .rx
                .items(cellIdentifier: ProductCell.id, cellType: ProductCell.self)) { [weak self] (_, product, cell) in
                    cell.product = product
                    self?.viewModel
                        .imagePublisher
                        .bind(to: cell.imageView
                            .rx
                            .image)
                        .disposed(by: self!.disposeBag)
                    
                    self?.viewModel.downloadImage(from: product.imageURL.small)
                }
                .disposed(by: disposeBag)
    }
}
