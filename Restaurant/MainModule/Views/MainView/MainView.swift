
import UIKit
import Lottie
import Firebase

final class MainView: UIViewController,UICollectionViewDelegateFlowLayout,MainViewProtocol {
    
    private var presenter: MainPresenter!
    
    var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .none
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    
     let loaderAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: Resources.LoaderAnimationView.loader)
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    
     var selectedCategory: FoodCategory? = .hotDishes

     let sections = MockData.shared.pageData

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainPresenter(view: self)

        setupViews()
        setupConstraints()
        setDelegate()
        presenter.viewDidLoad()
    }

    func showLoader() {
           loaderAnimationView.isHidden = false
           loaderAnimationView.play()
       }

       func hideLoader() {
           loaderAnimationView.stop()
           loaderAnimationView.isHidden = true
       }

       func reloadCollectionView() {
           collectionView.reloadData()
       }

       func showError(_ error: String) {
           print(error)
       }
    
    
     func presentProductDetailViewController(_ product: MenuItem, indexPath: IndexPath) {
        guard let selectedCategory = selectedCategory else { return }
        let productDetailVC = ProductDetailView(name: product.title, price: String(product.price), image: product.image, category: selectedCategory, indexPath: indexPath, descriptionForFood: product.description)
        
        if let sheet = productDetailVC.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                let targetHeight: CGFloat = 600
                return targetHeight
            }
            
            sheet.detents = [customDetent, .large()]
            sheet.largestUndimmedDetentIdentifier = nil
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 30
        }

        present(productDetailVC, animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(collectionView)
        collectionView.addSubview(loaderAnimationView)

        collectionView.register(SaleCollectionViewCell.self,
                                forCellWithReuseIdentifier: Resources.ReuseIdentifierForMainView.saleId)
        collectionView.register(CategoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: Resources.ReuseIdentifierForMainView.categoryId)
        collectionView.register(ExampleCollectionViewCell.self,
                                forCellWithReuseIdentifier: Resources.ReuseIdentifierForMainView.exampleId)
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: Resources.ReuseIdentifierForMainView.headerId)
        collectionView.collectionViewLayout = createLayout()
    }
    
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
  private func createLayout() -> UICollectionViewCompositionalLayout {
      
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.sections[sectionIndex]
            switch section {
                
            case .sales(_):
                return createSaleSection()
            case .category(_):
                return createCategorySection()
            case .foodForCategory(_):
                return createFoodForCategorySection()
            }
        }
   }
}
