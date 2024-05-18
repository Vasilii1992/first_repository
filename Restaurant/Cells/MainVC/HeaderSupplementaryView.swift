
import UIKit

final class HeaderSupplementaryView: UICollectionReusableView {
    
    private lazy var headerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: Resources.Fonts.timesNewRoman, size: 20)
        label.textColor = #colorLiteral(red: 0.4919037223, green: 0.4086572528, blue: 0.3491387367, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(headerBackgroundView)
        headerBackgroundView.addSubview(headerLabel)
      
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(categoryName: String) {
        headerLabel.text = categoryName
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([

                      headerBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
                      headerBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                      headerBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                      headerBackgroundView.heightAnchor.constraint(equalToConstant: 30),

                      headerLabel.centerYAnchor.constraint(equalTo: headerBackgroundView.centerYAnchor),
                      headerLabel.leadingAnchor.constraint(equalTo: headerBackgroundView.leadingAnchor, constant: 10),
                      headerLabel.trailingAnchor.constraint(equalTo: headerBackgroundView.trailingAnchor, constant: -10)
        ])
    }
}
