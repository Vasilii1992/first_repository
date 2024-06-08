

import Foundation

final class MockData {
    
    static let shared = MockData()
    
        let sales: [MenuItem] = [
        .init(image: "IMG_7428"),
        .init(image: "IMG_7429"),
        .init(image: "IMG_7427"),
        .init(image: "IMG_7420"),
        .init(image: "IMG_7413"),
        .init(image: "IMG_7415"),
        .init(image: "IMG_7412"),
        .init(image: "IMG_7411")
        
    ]
    
    var foodForCategory: [MenuItem] = []

    let categories: [FoodCategory] = [
        .salad, .soups, .hotDishes, .garnish, .burger, .pizza, .pasta, .dessert
    ]

    var pageData: [ListSection] {
        [
            .sales(sales),
            .category(categories.map {
                MenuItem(title: $0.title, image: $0.image, price: 0, category: $0, description: "")
            }),
            .foodForCategory(foodForCategory)
        ]
    }
}

/*
 
 
 
 You are an iOS developer. We have a project in which no architectural pattern is applied.Our task is to introduce the MVP pattern here.
 
 Here is the entire project code, where each class is a separate file:
 
 import UIKit
 import Firebase

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

     }
 }

 final class MenuDisplayViewController: UIViewController {
     
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
         
         fetchDataFromFirebase(selectedIndex: 0)
     }

     func fetchDataFromFirebase(selectedIndex: Int) {
            if !hasLoadedOnce {
                DispatchQueue.main.async {
                    self.loaderAnimationView.isHidden = false
                    self.loaderAnimationView.play()
                }
                hasLoadedOnce = true
            }
            
            let collectionName = selectedIndex == 0 ? alcoKey : nonAlcoKey

            APIManager.shared.fetchDrinksData(collectionName: collectionName) { [weak self] drinks, error in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    self.loaderAnimationView.stop()
                    self.loaderAnimationView.isHidden = true
                    
                    if let error = error {
                        print("Error getting documents: \(error)")
                        return
                    }

                    guard let drinks = drinks else {
                        print("No documents")
                        return
                    }

                    self.firebaseDrinks = drinks
                    self.myTableView.reloadData()
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

 final class DrinkDescriptionViewController: UIViewController {
    
     private var drinkDescription: String?
     private var name: String?

    private lazy var scrollView : UIScrollView = {
         let scrollView = UIScrollView()
         scrollView.translatesAutoresizingMaskIntoConstraints = false
         scrollView.alwaysBounceVertical = true
         scrollView.isDirectionalLockEnabled = true
         scrollView.indicatorStyle = .black
         return scrollView
     }()
     
     private lazy var nameLabel: UILabel = {
          let label = UILabel()
         label.createNewLabel(text: "",
                              color: .black,
                              size: 28,
                              font: Resources.Fonts.snellRoundhandBold)
                              return label
     }()
     
     private lazy var descriptionLabel: UILabel = {
         let label = UILabel()
        label.createNewLabel(text: "",
                             color: .black,
                             size: 17,
                             font: Resources.Fonts.palatinoItalic)
                             return label
     }()
     
     private lazy var productImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFit
         imageView.image = UIImage(named: "noImage")
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
     }()
     
     private let loaderAnimationView: LottieAnimationView = {
         let animationView = LottieAnimationView(name: Resources.LoaderAnimationView.loader)
         animationView.loopMode = .loop
         animationView.translatesAutoresizingMaskIntoConstraints = false
         return animationView
     }()

     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .white
         setupViews()
         setupConstraints()
     }
     
     func setupViews() {
         view.addSubview(scrollView)
         scrollView.addSubview(descriptionLabel)
         view.addSubview(productImageView)
         view.addSubview(loaderAnimationView)
         view.addSubview(nameLabel)
     }
     
     func configureCell(imageURL: String, nameL: String, description: String) {
         loaderAnimationView.isHidden = false
         loaderAnimationView.play()

         guard let url = URL(string: imageURL) else {
             loaderAnimationView.stop()
             loaderAnimationView.isHidden = true
             productImageView.image = UIImage(named: "noImage")
             nameLabel.text = nameL
             descriptionLabel.text = description
             return
         }

         productImageView.sd_setImage(with: url) { [weak self] (_, error, _, _) in
             guard let self = self else { return }

             self.loaderAnimationView.stop()
             self.loaderAnimationView.isHidden = true

             if let error = error {
                 print("Error loading image: \(error.localizedDescription)")
                 self.productImageView.image = UIImage(named: "noImage")
                 self.nameLabel.text = nameL
                 self.descriptionLabel.text = description
             }
         }
         
         nameLabel.text = nameL
         descriptionLabel.text = description
     }

     func setupConstraints() {

     }
 }


 final class APIManager {
         
     static let shared = APIManager()
     private init() {}
     
     private func configureFB() -> Firestore {
       var db: Firestore!
         let settings = FirestoreSettings()
         Firestore.firestore().settings = settings
         db = Firestore.firestore()
         return db
     }
     
     func fetchDrinksData(collectionName: String, completion: @escaping ([FirebaseDrink]?, Error?) -> Void) {
             let db = Firestore.firestore()
             db.collection(collectionName).getDocuments { snapshot, error in
                 if let error = error {
                     completion(nil, error)
                     return
                 }

                 guard let snapshot = snapshot else {
                     completion(nil, nil)
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

                 completion(drinks, nil)
         }
     }
 }

 final class FirebaseDrink {
     var subMenu: SubMenu
     var menu: [NameAndPrice]
     var isStatus: Bool

     var name: String
     var price: [VolumeAndPrice]
     var description: String
     var images: String
     
     init(subMenu: SubMenu, menu: [NameAndPrice], isStatus: Bool, name: String, price: [VolumeAndPrice], description: String, images: String) {
         self.subMenu = subMenu
         self.menu = menu
         self.isStatus = isStatus
         self.name = name
         self.price = price
         self.description = description
         self.images = images
     }
 }

 final class NameAndPrice {
     var name: String
     var price: [VolumeAndPrice]
     var description: String
     var images: String
     
     init(name: String, price: [VolumeAndPrice], description: String, images: String) {
         self.name = name
         self.price = price
         self.description = description
         self.images = images
     }
 }

 struct VolumeAndPrice {
     var volume: String?
     var price: Int?
 }

 final class SubMenu {
     var subMenuName: String
     var subMenuImage: String
     
     init(subMenuName: String, subMenuImage: String) {
         self.subMenuName = subMenuName
         self.subMenuImage = subMenuImage
     }
 }




 */

