import UIKit
import SDWebImage
import Lottie


final class DrinkDescriptionViewController: UIViewController {
   
    private var drinkDescription: String?
    private var name: String?

    var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.indicatorStyle = .black
        return scrollView
    }()
    
    private lazy var nameLabel: UILabel = {
         let label = UILabel()
        label.createNewLabel(text: "",
                             color: .black,
                             size: 28,
                             font: Resources.Fonts.snellRoundhandBold)
                             return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
       label.createNewLabel(text: "",
                            color: .black,
                            size: 17,
                            font: Resources.Fonts.palatinoItalic)
                            return label
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "noImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let loaderAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "Loader")
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(descriptionLabel)
        view.addSubview(productImageView)
        view.addSubview(loaderAnimationView)
        view.addSubview(nameLabel)
    }
    
    func configureCell(imageURL: String, nameL: String, description: String) {
        loaderAnimationView.isHidden = false
        loaderAnimationView.play()

        guard let url = URL(string: imageURL) else {
            loaderAnimationView.stop()
            loaderAnimationView.isHidden = true
            productImageView.image = UIImage(named: "noImage")
            nameLabel.text = nameL
            descriptionLabel.text = description
            return
        }

        productImageView.sd_setImage(with: url) { [weak self] (_, error, _, _) in
            guard let self = self else { return }

            self.loaderAnimationView.stop()
            self.loaderAnimationView.isHidden = true

            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                self.productImageView.image = UIImage(named: "noImage")
                self.nameLabel.text = nameL
                self.descriptionLabel.text = description
            }
        }
        
        nameLabel.text = nameL
        descriptionLabel.text = description
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            productImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
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
            
            scrollView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 40),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),


            descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            descriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9)

        ])
    }
}


