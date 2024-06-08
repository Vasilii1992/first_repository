import UIKit
import SDWebImage
import Lottie


final class DrinkDescriptionView: UIViewController {
   
    private var drinkDescription: String?
    private var name: String?

    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.indicatorStyle = .black
        return scrollView
    }()
    
     lazy var nameLabel: UILabel = {
         let label = UILabel()
        label.createNewLabel(text: "",
                             color: .black,
                             size: 28,
                             font: Resources.Fonts.snellRoundhandBold)
                             return label
    }()
    
     lazy var descriptionLabel: UILabel = {
        let label = UILabel()
       label.createNewLabel(text: "",
                            color: .black,
                            size: 17,
                            font: Resources.Fonts.palatinoItalic)
                            return label
    }()
    
     lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "noImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
     let loaderAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: Resources.LoaderAnimationView.loader)
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

}


