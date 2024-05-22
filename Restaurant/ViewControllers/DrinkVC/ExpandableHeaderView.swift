

import UIKit

protocol ExpandableHeaderViewDelegate: AnyObject {
    
    func toggleSection(header: ExpandableHeaderView, section: Int)
}
final class ExpandableHeaderView: UITableViewHeaderFooterView {
    
    var section: Int!
   weak var delegate: ExpandableHeaderViewDelegate?
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "questionmark")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    private lazy var alcoLabel: UILabel = {
        let label = UILabel()
       label.createNewLabel(text: "",
                            color: .black,
                            size: 17,
                            font: Resources.Fonts.palatinoItalic)
                            return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let tabHeader = UITapGestureRecognizer(target: self, action: #selector(clickingOnSubMenu))
        self.addGestureRecognizer(tabHeader)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(myImageView)
        contentView.addSubview(alcoLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            myImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            myImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            myImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            myImageView.widthAnchor.constraint(equalToConstant: 40),
            myImageView.heightAnchor.constraint(equalToConstant: 40),
            
            alcoLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            alcoLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 16)
                ])
        
    }
    
    @objc func clickingOnSubMenu(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    }
        
    func customInit(title: String, section: Int, delegate: ExpandableHeaderViewDelegate, image: String) {
        self.section = section
        self.delegate = delegate
        self.myImageView.image = UIImage(named: image)
        self.alcoLabel.text = title
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = .black
        self.contentView.backgroundColor = .white
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
}

