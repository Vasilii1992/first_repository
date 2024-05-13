
import UIKit

final class HeaderSupplementaryView: UICollectionReusableView {
    
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
        backgroundColor = #colorLiteral(red: 0.8907808065, green: 0.9306998849, blue: 0.82597965, alpha: 0.3488979719)
        addSubview(headerLabel)
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
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
        
        ])
    }
}
