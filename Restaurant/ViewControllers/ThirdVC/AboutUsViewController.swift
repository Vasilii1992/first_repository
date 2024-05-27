
import UIKit
import Lottie

final class AboutUsViewController: UIViewController {
    
    private let animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "thirdScreen")
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6

        setupViews()
        setupConstraints()
        animationView.play()
        privacyPolicyButton.addTarget(self, action: #selector(privacyPolicyAction), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImageAppearance()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.transform = CGAffineTransform(translationX: -view.bounds.width / 2, y: 0)
        
        }
    
    private lazy var informationLabel: UILabel = {
        var label = UILabel()
        label.text = Resources.Strings.informationLabel
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: Resources.Fonts.timesNewRoman, size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
       label.createNewLabel(text: Resources.Strings.phoneLabel,
                            color: .black,
                            size: 16,
                            font: Resources.Fonts.timesNewRoman)
                            return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "IMG_7431")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let privacyPolicyButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 250, height: 40))
        button.setTitle(Resources.Strings.privacyPolicy, for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont(name: Resources.Fonts.timesNewRoman, size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    @objc func privacyPolicyAction() {
        if let url = URL(string: Resources.Links.privacyPolicy) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
       }
    
    private func setupViews() {
        view.addSubview(informationLabel)
        view.addSubview(imageView)
        view.addSubview(phoneLabel)
        view.addSubview(privacyPolicyButton)
        view.addSubview(animationView)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            informationLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 150),
            informationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7),
            informationLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.6),
            
            phoneLabel.topAnchor.constraint(equalTo: informationLabel.bottomAnchor,constant: 80),
            phoneLabel.centerXAnchor.constraint(equalTo: informationLabel.centerXAnchor),
            phoneLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.6),

            privacyPolicyButton.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor,constant: 20),
            privacyPolicyButton.centerXAnchor.constraint(equalTo: phoneLabel.centerXAnchor),
            privacyPolicyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -140),
            

            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -view.bounds.width - 45),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor), 
            imageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            imageView.heightAnchor.constraint(equalToConstant: view.bounds.height),
            
            animationView.bottomAnchor.constraint(equalTo: phoneLabel.topAnchor,constant: 10),
            animationView.centerXAnchor.constraint(equalTo: phoneLabel.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 250),
            animationView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func animateImageAppearance() {
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.imageView.transform = CGAffineTransform.identity
            self.imageView.transform = CGAffineTransform(translationX: self.view.bounds.width / 2, y: 0)
        }, completion: nil)
    }
}
