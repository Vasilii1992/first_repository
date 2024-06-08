

import UIKit

extension ProductDetailView {
    
    func setupConstrains() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            productImageView.heightAnchor.constraint(equalToConstant: 200),
            
            loaderAnimationView.centerXAnchor.constraint(equalTo: productImageView.centerXAnchor),
            loaderAnimationView.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            loaderAnimationView.widthAnchor.constraint(equalToConstant: 100),
            loaderAnimationView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.6),

            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 120),
            priceLabel.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -20),
            
            scrollView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),


            descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            descriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9)
        ])
    }
    
    
}
