

import UIKit

extension MenuView {
    
    func setupConstraints() {
       customSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
       menuViewController.view.translatesAutoresizingMaskIntoConstraints = false
       
       NSLayoutConstraint.activate([
           customSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
           customSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
           customSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
           customSegmentedControl.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
           
           menuViewController.view.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 0),
           menuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           menuViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           menuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
       ])
   }
}
