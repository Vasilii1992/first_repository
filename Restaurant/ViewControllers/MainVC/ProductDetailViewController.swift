
import UIKit
import SDWebImage
import Lottie


final class ProductDetailViewController: UIViewController {
    
    private var name: String
    private var price: String
    private var image: String
    private var category: FoodCategory?
    private var indexPath: IndexPath?
    private var descriptionForFood: String
    let colorForPrice = #colorLiteral(red: 0.2793985307, green: 0.5675081015, blue: 0.1696840525, alpha: 1)

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
    }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
       label.createNewLabel(text: "",
                            color: .black,
                            size: 28,
                            font: Resources.Fonts.snellRoundhandBold)
                            return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
       label.createNewLabel(text: "",
                            color: colorForPrice ,
                            size: 30,
                            font: Resources.Fonts.timesNewRoman)
                            return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
       label.createNewLabel(text: "",
                            color: .black,
                            size: 19,
                            font: Resources.Fonts.noteworthyLight)
                            return label
    }()

    private let loaderAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "Loader")
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstrains()
        getTheData()
    }

    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(productImageView)
        view.addSubview(loaderAnimationView)
        view.addSubview(nameLabel)
        view.addSubview(priceLabel)
        view.addSubview(descriptionLabel)
    }
    
    private func getTheData() {
        let filteredItems = MockData.shared.foodForCategory.filter { $0.category == category }
        if let indexPath = indexPath, indexPath.row < filteredItems.count {
            let selectedItem = filteredItems[indexPath.row]
            loaderAnimationView.play()
            if let url = URL(string: selectedItem.image) {
                productImageView.sd_setImage(with: url) { _, _, _, _ in
                    self.loaderAnimationView.stop()
                    self.loaderAnimationView.isHidden = true
                }
            }
            nameLabel.text = selectedItem.title
            priceLabel.text = "\(selectedItem.price) ₽"
            descriptionLabel.text = selectedItem.description
        }

    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            productImageView.heightAnchor.constraint(equalToConstant: 200),
            
            loaderAnimationView.centerXAnchor.constraint(equalTo: productImageView.centerXAnchor),
            loaderAnimationView.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            loaderAnimationView.widthAnchor.constraint(equalToConstant: 100),
            loaderAnimationView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.6),

            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 120),
            priceLabel.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}