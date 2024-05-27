
import UIKit

extension UIView {
    func setGradientBackground() {
        
        let colorLeft = UIColor.lightGray.cgColor
        let colorRight = UIColor.white.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorLeft,colorRight]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.8, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIButton {
    static func createSegmentedButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Times New Roman", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

extension UILabel {
    
    func createNewLabel(text: String,color: UIColor,size: CGFloat, font: String) {
        self.text = text
        self.textAlignment = .center
        self.font = UIFont(name: font, size: size)
        self.textColor = color
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

extension String {
    func localized() -> String {
        NSLocalizedString(self,
                          tableName: "Localizable",
                          bundle: .main,
                          value: self,
                          comment: self)
    }
}



