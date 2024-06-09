
import UIKit
import Lottie

final class AboutUsViewController: UIViewController {
    
     let animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: Resources.LoaderAnimationView.thirdScreen)
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
     lazy var informationLabel: UILabel = {
        var label = UILabel()
        label.text = Resources.Strings.informationLabel
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: Resources.Fonts.timesNewRoman, size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
     lazy var phoneLabel: UILabel = {
        let label = UILabel()
       label.createNewLabel(text: Resources.Strings.phoneLabel,
                            color: .black,
                            size: 16,
                            font: Resources.Fonts.timesNewRoman)
                            return label
    }()
    
     lazy var imageView: UIImageView = {
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
    
    private func animateImageAppearance() {
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.imageView.transform = CGAffineTransform.identity
            self.imageView.transform = CGAffineTransform(translationX: self.view.bounds.width / 2, y: 0)
        }, completion: nil)
    }
}
