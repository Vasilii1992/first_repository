
import UIKit
import Firebase
import Lottie


final class MenuDisplayView: UIViewController,MenuViewProtocol {
    
    private var firebaseDrinks: [FirebaseDrink] = []
    private var hasLoadedOnce = false
    private var cellIdentifier = "ExpandableHeaderView"
    private var alcoKey = "alcoEng".localized()
    private var nonAlcoKey = "notAlcoEng".localized()
    
    
    private let loaderAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: Resources.LoaderAnimationView.loaderForBar)
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()

    private let myTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        
        return tableView
    }()    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        registerCells()
        setupDelegate()
        setupViews()
        setupConstraints()
        
       // fetchDataFromFirebase(selectedIndex: 0)
    }

//    func fetchDataFromFirebase(selectedIndex: Int) {
//           if !hasLoadedOnce {
//               DispatchQueue.main.async {
//                   self.loaderAnimationView.isHidden = false
//                   self.loaderAnimationView.play()
//               }
//               hasLoadedOnce = true
//           }
//           
//           let collectionName = selectedIndex == 0 ? alcoKey : nonAlcoKey
//
//           APIManager.shared.fetchDrinksData(collectionName: collectionName) { [weak self] drinks, error in
//               guard let self = self else { return }
//
//               DispatchQueue.main.async {
//                   self.loaderAnimationView.stop()
//                   self.loaderAnimationView.isHidden = true
//                   
//                   if let error = error {
//                       print("Error getting documents: \(error)")
//                       return
//                   }
//
//                   guard let drinks = drinks else {
//                       print("No documents")
//                       return
//                   }
//
//                   self.firebaseDrinks = drinks
//                   self.myTableView.reloadData()
//               }
//           }
//       }
    func showLoader() {
           DispatchQueue.main.async {
               self.loaderAnimationView.isHidden = false
               self.loaderAnimationView.play()
           }
       }
       
       func hideLoader() {
           DispatchQueue.main.async {
               self.loaderAnimationView.stop()
               self.loaderAnimationView.isHidden = true
           }
       }
       
       func updateDrinkList(_ drinks: [FirebaseDrink]) {
           DispatchQueue.main.async {
               self.firebaseDrinks = drinks
               self.myTableView.reloadData()
           }
       }
    func showError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }

   private func setupViews() {
        self.view.addSubview(myTableView)
       self.view.addSubview(loaderAnimationView)

    }
    private func setupDelegate() {
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    private func registerCells() {
        myTableView.register(AlcoViewCell.self, forCellReuseIdentifier: AlcoViewCell.identifier)
    }
    private func setupConstraints() {
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        loaderAnimationView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loaderAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loaderAnimationView.widthAnchor.constraint(equalToConstant: 300),
            loaderAnimationView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
extension MenuDisplayView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if firebaseDrinks[indexPath.section].isStatus {
            return 50
        } else {
            return 0
        }
 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let selectedDrink = firebaseDrinks[indexPath.section].menu[indexPath.row]
                let drinkDescriptionVC = DrinkDescriptionView()
        drinkDescriptionVC.configureCell(imageURL: selectedDrink.images,
                                         nameL: selectedDrink.name,
                                         description: selectedDrink.description)
        
                present(drinkDescriptionVC, animated: true)
        }
}
extension MenuDisplayView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return firebaseDrinks.count

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseDrinks[section].menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if firebaseDrinks[indexPath.section].isStatus {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AlcoViewCell.identifier) as? AlcoViewCell else {
                return UITableViewCell()
            }
            
            let nameAndPrice = firebaseDrinks[indexPath.section].menu[indexPath.row]
                        cell.configure(nameAndPrice: nameAndPrice)
            return cell
        } else {
            return UITableViewCell()
    }
  }
}


extension MenuDisplayView: ExpandableHeaderViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: cellIdentifier) as? ExpandableHeaderView
        if header == nil {
            header = ExpandableHeaderView(reuseIdentifier: cellIdentifier)
        }

        header?.customInit(title: firebaseDrinks[section].subMenu.subMenuName, section: section, delegate: self, image: firebaseDrinks[section].subMenu.subMenuImage)
        return header
    }

    func toggleSection(header: ExpandableHeaderView, section: Int) {
        firebaseDrinks[section].isStatus = !firebaseDrinks[section].isStatus
        
        myTableView.beginUpdates()
        for i in 0..<firebaseDrinks[section].menu.count {
            myTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        myTableView.endUpdates()
    }
}




