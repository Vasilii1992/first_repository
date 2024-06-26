
import UIKit


final class CategoryCollectionViewCell: UICollectionViewCell {
    
    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
       label.createNewLabel(text: "",
                            color: .black,
                            size: 17,
                            font: Resources.Fonts.palatinoItalic)
                            return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 2
                layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                backgroundColor = #colorLiteral(red: 0.8907808065, green: 0.9306998849, blue: 0.82597965, alpha: 0.3488979719)

            } else {
                layer.borderWidth = 0
                backgroundColor = .white

            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        addSubview(categoryLabel)
        addSubview(categoryImageView)
    }
    
    func configureCell(categoryName: String, imageName: String) {
        categoryLabel.text = categoryName
        categoryImageView.image = UIImage(named: imageName)
    }
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            categoryLabel.heightAnchor.constraint(equalToConstant: 20),
            
            categoryImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            categoryImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            categoryImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            categoryImageView.bottomAnchor.constraint(equalTo: categoryLabel.topAnchor, constant: -4)
        
        ])
    }
}

