//
//  AlcoViewCell.swift
//  Restaurant
//
//  Created by Василий Тихонов on 27.02.2024.
//

import UIKit


 final class AlcoViewCell: UITableViewCell {
    
    static let identifier = "MyCell"

    private lazy var alcoLabel: UILabel = {
        let label = UILabel()
       label.createNewLabel(text: "",
                            color: .black,
                            size: 17,
                            font: Resources.Fonts.palatinoItalic)
                            return label
    }()
    
    private lazy var mlLabel: UILabel = {
        let label = UILabel()
        label.createNewLabel(text: "330ml",
                            color: .black,
                            size: 10,
                            font: Resources.Fonts.palatinoItalic)
                            return label
    }()
    
    private let mlLabel2: UILabel = {
        let label = UILabel()
        label.createNewLabel(text: "450ml",
                            color: .black,
                            size: 10,
                            font: Resources.Fonts.palatinoItalic)
                            return label
    }()
    
    private let mlLabel3: UILabel = {
        let label = UILabel()
        label.createNewLabel(text: "500ml",
                            color: .black,
                            size: 10,
                            font: Resources.Fonts.palatinoItalic)
                            return label
    }()
    
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.createNewLabel(text: "",
                            color: .black,
                            size: 17,
                            font: Resources.Fonts.palatinoItalic)
                            return label
    }()
    private let priceLabel2: UILabel = {
        let label = UILabel()
        label.createNewLabel(text: "",
                            color: .black,
                            size: 17,
                            font: Resources.Fonts.palatinoItalic)
                            return label
    }()
    private let priceLabel3: UILabel = {
        let label = UILabel()
        label.createNewLabel(text: "",
                            color: .black,
                            size: 17,
                            font: Resources.Fonts.palatinoItalic)
                            return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(nameAndPrice: NameAndPrice) {
        alcoLabel.text = nameAndPrice.name
        
        guard nameAndPrice.price.count > 0 else {
            priceLabel.text = "No Price"
            mlLabel.text = ""
            mlLabel2.text = ""
            mlLabel3.text = ""
            return
        }
        
        mlLabel.text = nameAndPrice.price[0].volume
        mlLabel2.text = nameAndPrice.price.count > 1 ? nameAndPrice.price[1].volume : ""
        mlLabel3.text = nameAndPrice.price.count > 2 ? nameAndPrice.price[2].volume : ""
        
        priceLabel.text = nameAndPrice.price.count > 0 ? "\(nameAndPrice.price[0].price ?? 0) ₽" : ""
        priceLabel2.text = nameAndPrice.price.count > 1 ? "\(nameAndPrice.price[1].price ?? 0) ₽" : ""
        priceLabel3.text = nameAndPrice.price.count > 2 ? "\(nameAndPrice.price[2].price ?? 0) ₽" : ""
    }

    
    private func setupUI() {
        contentView.addSubview(alcoLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceLabel2)
        contentView.addSubview(priceLabel3)
        contentView.addSubview(mlLabel)
        contentView.addSubview(mlLabel2)
        contentView.addSubview(mlLabel3)
        
        
        
        NSLayoutConstraint.activate([
            alcoLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            alcoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 20),
            alcoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            
            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 20),
            priceLabel.leadingAnchor.constraint(equalTo: mlLabel.leadingAnchor),
            
            priceLabel2.topAnchor.constraint(equalTo: contentView.topAnchor),
            priceLabel2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 20),
            priceLabel2.leadingAnchor.constraint(equalTo: mlLabel2.leadingAnchor),
            
            priceLabel3.topAnchor.constraint(equalTo: contentView.topAnchor),
            priceLabel3.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 20),
            priceLabel3.leadingAnchor.constraint(equalTo: mlLabel3.leadingAnchor),
            
            mlLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: -25),
            mlLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 240),
            mlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            mlLabel2.topAnchor.constraint(equalTo: contentView.topAnchor,constant: -25),
            mlLabel2.leadingAnchor.constraint(equalTo: mlLabel.trailingAnchor,constant: 80),
            mlLabel2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            mlLabel3.topAnchor.constraint(equalTo: contentView.topAnchor,constant: -25),
            mlLabel3.leadingAnchor.constraint(equalTo: mlLabel2.trailingAnchor,constant: 80),
            mlLabel3.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

        
        ])
    }    
}

