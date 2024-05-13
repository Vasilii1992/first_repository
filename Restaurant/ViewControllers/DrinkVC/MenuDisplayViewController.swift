
import UIKit
import FirebaseDatabase
import FirebaseFirestoreInternal
import Lottie


final class MenuDisplayViewController: UIViewController {
    
    private var firebaseDrinks: [FirebaseDrink] = []
    private var hasLoadedOnce = false
    private var cellIdentifier = "ExpandableHeaderView"
    private var alcoKey = "alcoEng".localized()
    private var nonAlcoKey = "notAlcoEng".localized()
    
    

    
    private let loaderAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "LoaderForBar")
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()

    private let  myTableView: UITableView = {
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
        
        fetchDataFromFirebase(selectedIndex: 0)
    }
    
//     func fetchDataFromFirebase(selectedIndex: Int) {
//
//         if !hasLoadedOnce {
//             loaderAnimationView.isHidden = false
//             loaderAnimationView.play()
//             hasLoadedOnce = true
//         }
//        let db = Firestore.firestore()
//         let collectionName = selectedIndex == 0 ? alcoKey : nonAlcoKey
//         
//        db.collection(collectionName).getDocuments { [weak self] snapshot, error in
//            guard let self = self else { return }
//            
//            DispatchQueue.main.async {
//                 self.loaderAnimationView.stop()
//                 self.loaderAnimationView.isHidden = true
//             }
//
//            if let error = error {
//                print("Error getting documents: \(error)")
//                return
//            }
//
//            guard let snapshot = snapshot else {
//                print("No documents")
//                return
//            }
//
//            var drinks: [FirebaseDrink] = []
//            for document in snapshot.documents {
//                let data = document.data()
//                guard let subMenuName = data["subMenuName"] as? String,
//                      let subMenuImage = data["subMenuImage"] as? String,
//                      let drinksData = data["menu"] as? [[String: Any]] else {
//                    continue
//                }
//
//                var menu: [NameAndPrice] = []
//                for drinkData in drinksData {
//                    guard let name = drinkData["name"] as? String,
//                          let description = drinkData["description"] as? String,
//                          let images = drinkData["images"] as? String,
//                          let priceData = drinkData["price"] as? [[String: Any]] else {
//                        continue
//                    }
//
//                    var volumeAndPrices: [VolumeAndPrice] = []
//                    for priceEntry in priceData {
//                        guard let volume = priceEntry["volume"] as? String,
//                              let price = priceEntry["price"] as? Int else {
//                            continue
//                        }
//                        let volumeAndPrice = VolumeAndPrice(volume: volume, price: price)
//                        volumeAndPrices.append(volumeAndPrice)
//                    }
//
//                    let drink = NameAndPrice(name: name,
//                                             price: volumeAndPrices,
//                                             description: description,
//                                             images: images)
//                    menu.append(drink)
//                }
//
//                let subMenu = SubMenu(subMenuName: subMenuName, subMenuImage: subMenuImage)
//                let firebaseDrink = FirebaseDrink(subMenu: subMenu,
//                                                  menu: menu,
//                                                  isStatus: false,
//                                                  name: subMenuName,
//                                                  price: [],
//                                                  description: "",
//                                                  images: subMenuImage)
//                drinks.append(firebaseDrink)
//            }
//
//            self.firebaseDrinks = drinks
//            self.myTableView.reloadData()
//        }
//    }
    func fetchDataFromFirebase(selectedIndex: Int) {
        if !hasLoadedOnce {
            DispatchQueue.main.async {
                self.loaderAnimationView.isHidden = false
                self.loaderAnimationView.play()
            }
            hasLoadedOnce = true
        }
        
        let db = Firestore.firestore()
        let collectionName = selectedIndex == 0 ? alcoKey : nonAlcoKey

        // Perform the database fetch on a background thread
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            db.collection(collectionName).getDocuments { snapshot, error in
                guard let self = self else { return }

                // Switch back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.loaderAnimationView.stop()
                    self.loaderAnimationView.isHidden = true
                    
                    if let error = error {
                        print("Error getting documents: \(error)")
                        return
                    }

                    guard let snapshot = snapshot else {
                        print("No documents")
                        return
                    }

                    var drinks: [FirebaseDrink] = []
                    for document in snapshot.documents {
                        let data = document.data()
                        guard let subMenuName = data["subMenuName"] as? String,
                              let subMenuImage = data["subMenuImage"] as? String,
                              let drinksData = data["menu"] as? [[String: Any]] else {
                            continue
                        }

                        var menu: [NameAndPrice] = []
                        for drinkData in drinksData {
                            guard let name = drinkData["name"] as? String,
                                  let description = drinkData["description"] as? String,
                                  let images = drinkData["images"] as? String,
                                  let priceData = drinkData["price"] as? [[String: Any]] else {
                                continue
                            }

                            var volumeAndPrices: [VolumeAndPrice] = []
                            for priceEntry in priceData {
                                guard let volume = priceEntry["volume"] as? String,
                                      let price = priceEntry["price"] as? Int else {
                                    continue
                                }
                                let volumeAndPrice = VolumeAndPrice(volume: volume, price: price)
                                volumeAndPrices.append(volumeAndPrice)
                            }

                            let drink = NameAndPrice(name: name,
                                                     price: volumeAndPrices,
                                                     description: description,
                                                     images: images)
                            menu.append(drink)
                        }

                        let subMenu = SubMenu(subMenuName: subMenuName, subMenuImage: subMenuImage)
                        let firebaseDrink = FirebaseDrink(subMenu: subMenu,
                                                          menu: menu,
                                                          isStatus: false,
                                                          name: subMenuName,
                                                          price: [],
                                                          description: "",
                                                          images: subMenuImage)
                        drinks.append(firebaseDrink)
                    }

                    self.firebaseDrinks = drinks
                    self.myTableView.reloadData()
                }
            }
        }
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
extension MenuDisplayViewController: UITableViewDelegate {
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
                let drinkDescriptionVC = DrinkDescriptionViewController()
        drinkDescriptionVC.configureCell(imageURL: selectedDrink.images,
                                         nameL: selectedDrink.name,
                                         description: selectedDrink.description)
        
                present(drinkDescriptionVC, animated: true)
        }
    
    
}
extension MenuDisplayViewController: UITableViewDataSource {
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


extension MenuDisplayViewController: ExpandableHeaderViewDelegate {

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




