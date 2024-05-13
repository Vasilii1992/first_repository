

import UIKit
import FirebaseDatabase


final class MenuViewController: UIViewController {
    

    private let menuViewController = MenuDisplayViewController()
    private let customSegmentedControl = CustomSegmentedControl(Resources.Strings.CustomSegmentedControl.alcohol,
                                                                Resources.Strings.CustomSegmentedControl.nonAlcohol)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        add(childViewController: menuViewController)
        
        setupViews()
        setupConstraints()
        customSegmentedControl.selectedIndex = 0
        customSegmentedControl.valueChangedHandler = { [weak self] segmentedControl in
             let selectedIndex = segmentedControl.selectedIndex
            self?.menuViewController.fetchDataFromFirebase(selectedIndex: selectedIndex)
        }
    }
 
    private func add(childViewController: UIViewController) {
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    private func setupViews() {
        view.addSubview(customSegmentedControl)
    }
    
    private func setupConstraints() {
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
    
    @objc private func segmentedControlValueChanged(sender: CustomSegmentedControl) {

    }
}

