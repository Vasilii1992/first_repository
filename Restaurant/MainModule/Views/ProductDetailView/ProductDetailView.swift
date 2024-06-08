
import UIKit
import SDWebImage
import Lottie


final class ProductDetailView: UIViewController, ProductDetailViewProtocol {
    
    private var presenter: ProductDetailPresenter!
    private var name: String
    private var price: String
    private var image: String
    private var category: FoodCategory?
    private var indexPath: IndexPath?
    private var descriptionForFood: String

    init() {
        self.name = ""
        self.price = ""
        self.image = ""
        self.descriptionForFood = ""
        super.init(nibName: nil, bundle: nil)
    }
    
    init(name: String, price: String, image: String, category: FoodCategory?, indexPath: IndexPath?, descriptionForFood: String) {
        self.name = name
        self.price = price
        self.image = image
        self.category = category
        self.indexPath = indexPath
        self.descriptionForFood = descriptionForFood
        super.init(nibName: nil, bundle: nil)
        self.presenter = ProductDetailPresenter(view: self, model: MockData.shared, category: category, indexPath: indexPath)

    }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
     lazy var scrollView : UIScrollView = {
         let scrollView = UIScrollView()
         scrollView.translatesAutoresizingMaskIntoConstraints = false
         scrollView.alwaysBounceVertical = true
         scrollView.isDirectionalLockEnabled = true
         scrollView.indicatorStyle = .black
         return scrollView
     }()

     lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
     lazy var nameLabel: UILabel = {
        let label = UILabel()
       label.createNewLabel(text: "",
                            color: .black,
                            size: 28,
                            font: Resources.Fonts.snellRoundhandBold)
                            return label
    }()
    
    
     lazy var priceLabel: UILabel = {
        let label = UILabel()
       label.createNewLabel(text: "",
                            color: .colorForPrice,
                            size: 30,
                            font: Resources.Fonts.timesNewRoman)
                            return label
    }()
    
     lazy var descriptionLabel: UILabel = {
        let label = UILabel()
       label.createNewLabel(text: "",
                            color: .black,
                            size: 19,
                            font: Resources.Fonts.noteworthyLight)
                            return label
    }()

     let loaderAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: Resources.LoaderAnimationView.loader)
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstrains()
        presenter.getProductData()
    }

    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(productImageView)
        view.addSubview(loaderAnimationView)
        view.addSubview(nameLabel)
        view.addSubview(priceLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(descriptionLabel)
    }
    
    
    func displayProduct(name: String, price: String, imageUrl: URL, description: String) {
        nameLabel.text = name
        priceLabel.text = price
        descriptionLabel.text = description
        productImageView.sd_setImage(with: imageUrl) { [weak self] _, _, _, _ in
            self?.loaderAnimationView.stop()
            self?.loaderAnimationView.isHidden = true
        }
    }

    func showLoadingAnimation() {
        loaderAnimationView.play()
    }

    func hideLoadingAnimation() {
        loaderAnimationView.stop()
        loaderAnimationView.isHidden = true
    }
    
    
    deinit {
        loaderAnimationView.stop()
        print("ProductDetailViewController deinitialized")
    }
}
