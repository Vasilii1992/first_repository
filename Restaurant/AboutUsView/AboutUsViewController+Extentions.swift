

import UIKit

extension AboutUsViewController {
    
    func setupConstraints() {
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
}
