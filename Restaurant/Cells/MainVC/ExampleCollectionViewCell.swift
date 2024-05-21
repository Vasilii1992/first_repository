

import UIKit
import SDWebImage
import Lottie

final class ExampleCollectionViewCell: UICollectionViewCell {
    
  
    private lazy var foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let backgroundTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8907808065, green: 0.9306998849, blue: 0.82597965, alpha: 0.3488979719)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Default name"
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .exampleViewCellPrice
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loaderAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "Loader")
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    private var currentImageURL: String?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(foodImageView)
        addSubview(loaderAnimationView)
        addSubview(backgroundTitleView)
        backgroundTitleView.addSubview(nameLabel)
        backgroundTitleView.addSubview(priceLabel)
    }

    func configureCell(imageURL: String, nameL: String, price: Int, isDataLoaded: Bool) {
            if isDataLoaded {
                loaderAnimationView.isHidden = true
                loaderAnimationView.stop()
            } else {
                loaderAnimationView.isHidden = false
                loaderAnimationView.play()
            }

            foodImageView.image = UIImage(named: "placeholder_image")

            if let url = URL(string: imageURL) {
                foodImageView.sd_setImage(with: url) { _, _, _, _ in
                    self.loaderAnimationView.stop()
                    self.loaderAnimationView.isHidden = true
                }
            }
            nameLabel.text = nameL
            priceLabel.text = "\(price) ₽"
        }

    
    func setConstraints() {
        NSLayoutConstraint.activate([

            foodImageView.topAnchor.constraint(equalTo: topAnchor),
            foodImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            foodImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            foodImageView.bottomAnchor.constraint(equalTo: backgroundTitleView.bottomAnchor,constant: 50),
            
            loaderAnimationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loaderAnimationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loaderAnimationView.widthAnchor.constraint(equalToConstant: 100),
            loaderAnimationView.heightAnchor.constraint(equalToConstant: 100),

            backgroundTitleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundTitleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundTitleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundTitleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),

            nameLabel.centerYAnchor.constraint(equalTo: backgroundTitleView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: backgroundTitleView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: backgroundTitleView.widthAnchor, multiplier: 0.6),

            priceLabel.centerYAnchor.constraint(equalTo: backgroundTitleView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: backgroundTitleView.trailingAnchor, constant: -16)

        ])
    }
}
