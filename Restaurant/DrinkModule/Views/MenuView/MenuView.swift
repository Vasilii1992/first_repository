

import UIKit
import Firebase

final class MenuView: UIViewController {
    

     let menuViewController = MenuDisplayView()
     let customSegmentedControl = CustomSegmentedControl(Resources.Strings.CustomSegmentedControl.alcohol,
                                                                Resources.Strings.CustomSegmentedControl.nonAlcohol)
    private var presenter: MenuPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        add(childViewController: menuViewController)
        presenter = MenuPresenter(view: menuViewController)
        setupViews()
        setupConstraints()
        customSegmentedControl.selectedIndex = 0
        customSegmentedControl.valueChangedHandler = { [weak self] segmentedControl in
             let selectedIndex = segmentedControl.selectedIndex
             self?.presenter?.fetchData(selectedIndex: selectedIndex)

        }
        presenter?.viewDidLoad()

    }
 
    private func add(childViewController: UIViewController) {
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    private func setupViews() {
        view.addSubview(customSegmentedControl)
    }
}

