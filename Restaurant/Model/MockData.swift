

import Foundation

final class MockData {
    
    static let shared = MockData()
    
    private let sales: [MenuItem] = [
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

    private let categories: [FoodCategory] = [
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
Ты IOS разрабодчик.У нас есть приложение,которое нужно проверить на утечку данных,чтобы при закрытии контролера,память зарезервированая под этот контролер высвобождалась.Проверь код и при необходимости исправь его,чтобы оптимизировать приложение.
 
 You're an iOS developer.We have an application that needs to be checked for data leakage so that when the controller is closed, the memory reserved for this controller is released.Check the code and correct it if necessary to optimize the application.
 Write only the part of the code that needs to be changed.
 
 import UIKit
 import Lottie
 import Firebase
 import FirebaseDatabase
 import FirebaseFirestore


 final class ViewController: UIViewController,UICollectionViewDelegateFlowLayout {

     private var isDataLoadedForCurrentGroup: Bool = false
     
     private var foodItemKey = "foodItemsEng".localized()

     private let collectionView: UICollectionView = {
         let collectionViewLayout = UICollectionViewLayout()
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
         collectionView.backgroundColor = .none
         collectionView.bounces = false
         collectionView.translatesAutoresizingMaskIntoConstraints = false

         return collectionView
     }()
     
     private let loaderAnimationView: LottieAnimationView = {
         let animationView = LottieAnimationView(name: "Animation")
         animationView.loopMode = .loop
         animationView.translatesAutoresizingMaskIntoConstraints = false
         return animationView
     }()
     
     
     private var selectedCategory: FoodCategory? = .hotDishes
     
     private let saleId = "StoriesCollectionViewCell"
     private let categoryId = "PopularCollectioniewCell"
     private let exampleId = "ComingSoonCollectionView"
     private let headerId = "HeaderSupplementaryView"
     
     private let sections = MockData.shared.pageData

     override func viewDidLoad() {
         super.viewDidLoad()

         setupViews()
         setupConstrains()
         setDelegate()
         fetchFoodDataFromFirebase()

     }
     
     private func presentProductDetailViewController(_ product: MenuItem, indexPath: IndexPath) {
         guard let selectedCategory = selectedCategory else { return }
         let productDetailVC = ProductDetailViewController(name: product.title, price: String(product.price), image: product.image, category: selectedCategory, indexPath: indexPath, descriptionForFood: product.description)
         
         if let sheet = productDetailVC.sheetPresentationController {
             let customDetent = UISheetPresentationController.Detent.custom { context in
                 let targetHeight: CGFloat = 600
                 return targetHeight
             }
             
             sheet.detents = [customDetent, .large()]
             sheet.largestUndimmedDetentIdentifier = nil
             sheet.prefersScrollingExpandsWhenScrolledToEdge = false
             sheet.prefersEdgeAttachedInCompactHeight = true
             sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
             sheet.prefersGrabberVisible = true
             sheet.preferredCornerRadius = 30
         }

         present(productDetailVC, animated: true, completion: nil)
     }
     
     func fetchFoodDataFromFirebase() {
             DispatchQueue.main.async {
                 self.loaderAnimationView.isHidden = false
                 self.loaderAnimationView.play()
             }

             APIManager.shared.fetchFoodDataFromFirebase(foodItemKey: foodItemKey) { [weak self] foodItems, error in
                 guard let self = self else { return }

                 DispatchQueue.global(qos: .userInitiated).async {
                     if let error = error {
                         DispatchQueue.main.async {
                             print("Error getting documents: \(error)")
                             self.loaderAnimationView.stop()
                             self.loaderAnimationView.isHidden = true
                         }
                         return
                     }

                     guard let foodItems = foodItems else {
                         DispatchQueue.main.async {
                             print("No documents found")
                             self.loaderAnimationView.stop()
                             self.loaderAnimationView.isHidden = true
                         }
                         return
                     }

                     MockData.shared.foodForCategory = foodItems

                     DispatchQueue.main.async {
                         self.collectionView.reloadData()
                         self.loaderAnimationView.stop()
                         self.loaderAnimationView.isHidden = true
                     }
                 }
             }
         }

     private func setupViews() {
         view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
         view.addSubview(collectionView)
         collectionView.addSubview(loaderAnimationView)

         collectionView.register(SaleCollectionViewCell.self,
                                 forCellWithReuseIdentifier: saleId)
         collectionView.register(CategoryCollectionViewCell.self,
                                 forCellWithReuseIdentifier: categoryId)
         collectionView.register(ExampleCollectionViewCell.self,
                                 forCellWithReuseIdentifier: exampleId)
         collectionView.register(HeaderSupplementaryView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: headerId)
         collectionView.collectionViewLayout = createLayout()
     }
     
     private func setupConstrains() {
         NSLayoutConstraint.activate([
             
             collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
             collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
             collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
             collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
             
             loaderAnimationView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
             loaderAnimationView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: 160),
             loaderAnimationView.widthAnchor.constraint(equalToConstant: 150),
             loaderAnimationView.heightAnchor.constraint(equalToConstant: 300)
                    
         ])
         
     }
     
     private func setDelegate() {
         collectionView.delegate = self
         collectionView.dataSource = self
     }
     
   private func createLayout() -> UICollectionViewCompositionalLayout {
       
         UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
             guard let self = self else { return nil }
             let section = self.sections[sectionIndex]
             switch section {
                 
             case .sales(_):
                 return createSaleSection()
             case .category(_):
                 return createCategorySection()
             case .foodForCategory(_):
                 return createFoodForCategorySection()
             }
         }
    }
     
     private func createLayoutSection(group: NSCollectionLayoutGroup,
                                        behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
                                        interGroupSpacing: CGFloat,
                                        supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem],
                                        contentInsetsReference: UIContentInsetsReference) -> NSCollectionLayoutSection {
           let section = NSCollectionLayoutSection(group: group)
           section.orthogonalScrollingBehavior = behavior
           section.interGroupSpacing = interGroupSpacing
           section.boundarySupplementaryItems = supplementaryItems
           section.supplementaryContentInsetsReference = contentInsetsReference
           return section
       }
       
       
       private func createSaleSection() -> NSCollectionLayoutSection {
           
           let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .fractionalHeight(1)))
           let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.15),
                                                                        heightDimension: .fractionalHeight(0.33)),
                                                                        subitems: [item])
           
           let section = createLayoutSection(group: group,
                                             behavior: .groupPaging,
                                             interGroupSpacing: 5,
                                             supplementaryItems: [],
                                             contentInsetsReference: .automatic)
               section.contentInsets = .init(top: -60, leading: 0, bottom: -10, trailing: 0)
           return section
       }
       
       private func createCategorySection() -> NSCollectionLayoutSection {
           
       let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.25),
                                                           heightDimension: .fractionalHeight(1)))
       let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                        heightDimension: .fractionalHeight(0.1)),
                                                                        subitems: [item])
           group.interItemSpacing = .flexible(10)
           
           let section = createLayoutSection(group: group,
                                             behavior: .none,
                                             interGroupSpacing: 10,
                                             supplementaryItems: [suplementaryHeaderItem()],
                                             contentInsetsReference: .automatic)
               section.contentInsets = .init(top: 5, leading: 10, bottom: 5, trailing: 10)
           
           return section
       }
       
       private func createFoodForCategorySection() -> NSCollectionLayoutSection {
           
           let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                               heightDimension: .fractionalHeight(1)))
           let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.75),
                                                                        heightDimension: .fractionalHeight(0.35)),
                                                                        subitems: [item])
           
           let section = createLayoutSection(group: group,
                                             behavior: .continuous,
                                             interGroupSpacing: 10,
                                             supplementaryItems: [suplementaryHeaderItem()],
                                             contentInsetsReference: .automatic)
               section.contentInsets = .init(top: -100, leading: 10, bottom: 0, trailing: 0)
           
           return section
   }
       
       private func suplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
           .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                   heightDimension: .estimated(28)),
                 elementKind: UICollectionView.elementKindSectionHeader,
                 alignment: .top)
       }
     deinit {
         print("ViewController deinitialized")
     }
 }


 extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
             print("Collection view tapped at section \(indexPath.section) and row \(indexPath.row)")

             switch sections[indexPath.section] {
             case .category(let categories):
                 if indexPath.row < categories.count {
                     selectedCategory = categories[indexPath.row].category
                     print("Category selected: \(String(describing: selectedCategory))")
                     collectionView.reloadSections(IndexSet(integer: sections.firstIndex { $0.title == Resources.Strings.foodForCategory } ?? 0))
                 }
             case .foodForCategory:
                 let examples = MockData.shared.foodForCategory.filter { $0.category == selectedCategory }
                 print("Total items in examples: \(examples.count), selectedCategory: \(String(describing: selectedCategory))")
                 if indexPath.row < examples.count {
                     let selectedProduct = examples[indexPath.row]
                     print("Selected product: \(selectedProduct.title)")
                     presentProductDetailViewController(selectedProduct, indexPath: indexPath)
                 } else {
                     print("Selected index \(indexPath.row) is out of range for examples count \(examples.count)")
                 }
             default:
                 print("Unhandled section tapped.")
                 break
             }
         }

     func numberOfSections(in collectionView: UICollectionView) -> Int {
         sections.count
     }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
             switch sections[section] {
             case .sales(let items), .category(let items):
                 return items.count
             case .foodForCategory:
                 if let selectedCategory = selectedCategory {
                     return MockData.shared.foodForCategory.filter { $0.category == selectedCategory }.count
                 } else {
                     return MockData.shared.foodForCategory.count
                 }
             }
         }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch sections[indexPath.section] {
            case .sales(let sale):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: saleId, for: indexPath) as! SaleCollectionViewCell
                cell.configureCell(imageNames: sale.map { $0.image })
                return cell
            case .foodForCategory:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: exampleId, for: indexPath) as! ExampleCollectionViewCell
                let filteredItems = MockData.shared.foodForCategory.filter { $0.category == selectedCategory }
                let foodItem = filteredItems[indexPath.row]
                cell.configureCell(imageURL: foodItem.image, nameL: foodItem.title, price: foodItem.price, isDataLoaded: true)
                return cell
            case .category(let category):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryId, for: indexPath) as! CategoryCollectionViewCell
                cell.configureCell(categoryName: category[indexPath.row].title, imageName: category[indexPath.row].image)
                return cell
            }
        }

     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         switch kind {
         case UICollectionView.elementKindSectionHeader:
             let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                          withReuseIdentifier: headerId,
                                                                          for: indexPath) as! HeaderSupplementaryView
             switch sections[indexPath.section] {
             case .category(_):
                 header.configureHeader(categoryName: sections[indexPath.section].title)
             default:
                 header.configureHeader(categoryName: sections[indexPath.section].title)
             }
             return header
         default:
             return UICollectionReusableView()
         }
     }
 }
 final class ProductDetailViewController: UIViewController {
     
     private var name: String
     private var price: String
     private var image: String
     private var category: FoodCategory?
     private var indexPath: IndexPath?
     private var descriptionForFood: String

     init() {
         self.name = ""
         self.price = ""
         self.image = ""
         self.descriptionForFood = ""
         super.init(nibName: nil, bundle: nil)
     }
     
     init(name: String, price: String, image: String, category: FoodCategory?, indexPath: IndexPath?, descriptionForFood: String) {
         self.name = name
         self.price = price
         self.image = image
         self.category = category
         self.indexPath = indexPath
         self.descriptionForFood = descriptionForFood
         super.init(nibName: nil, bundle: nil)
     }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
     }
     
     private var scrollView : UIScrollView = {
          let scrollView = UIScrollView()
          scrollView.translatesAutoresizingMaskIntoConstraints = false
          scrollView.alwaysBounceVertical = true
          scrollView.isDirectionalLockEnabled = true
          scrollView.indicatorStyle = .black
          return scrollView
      }()

     private lazy var productImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFit
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
     }()
     
     private lazy var nameLabel: UILabel = {
         let label = UILabel()
        label.createNewLabel(text: "",
                             color: .black,
                             size: 28,
                             font: Resources.Fonts.snellRoundhandBold)
                             return label
     }()
     
     private lazy var priceLabel: UILabel = {
         let label = UILabel()
        label.createNewLabel(text: "",
                             color: .colorForPrice,
                             size: 30,
                             font: Resources.Fonts.timesNewRoman)
                             return label
     }()
     
     private lazy var descriptionLabel: UILabel = {
         let label = UILabel()
        label.createNewLabel(text: "",
                             color: .black,
                             size: 19,
                             font: Resources.Fonts.noteworthyLight)
                             return label
     }()

     private let loaderAnimationView: LottieAnimationView = {
         let animationView = LottieAnimationView(name: "Loader")
         animationView.loopMode = .loop
         animationView.translatesAutoresizingMaskIntoConstraints = false
         return animationView
     }()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         setupViews()
         setupConstrains()
         getTheData()
     }

     private func setupViews() {
         view.backgroundColor = .white
         
         view.addSubview(productImageView)
         view.addSubview(loaderAnimationView)
         view.addSubview(nameLabel)
         view.addSubview(priceLabel)
         view.addSubview(scrollView)
         scrollView.addSubview(descriptionLabel)
     }
     
     private func getTheData() {
         let filteredItems = MockData.shared.foodForCategory.filter { $0.category == category }
         if let indexPath = indexPath, indexPath.row < filteredItems.count {
             let selectedItem = filteredItems[indexPath.row]
             loaderAnimationView.play()
             if let url = URL(string: selectedItem.image) {
                 productImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
                     guard let self = self else { return }
                     self.loaderAnimationView.stop()
                     self.loaderAnimationView.isHidden = true
                 }
             }
             nameLabel.text = selectedItem.title
             priceLabel.text = "\(selectedItem.price) ₽"
             descriptionLabel.text = selectedItem.description
         }

     }
     
     private func setupConstrains() {
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


             descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
             descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
             descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
             descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
             descriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9)
         ])
     }
     
     deinit {
         print("ProductDetailViewController deinitialized")
     }
 }
 final class ExampleCollectionViewCell: UICollectionViewCell {
     
   
     private lazy var foodImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFit
         imageView.clipsToBounds = true
         imageView.layer.cornerRadius = 10
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
     }()

     private let backgroundTitleView: UIView = {
         let view = UIView()
         view.backgroundColor = #colorLiteral(red: 0.8907808065, green: 0.9306998849, blue: 0.82597965, alpha: 0.3488979719)
         view.layer.cornerRadius = 10
         view.clipsToBounds = true
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()

     private lazy var nameLabel: UILabel = {
         let label = UILabel()
         label.text = "Default name"
         label.textAlignment = .left
         label.numberOfLines = 2
         label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
         label.textColor = .black
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()

     private lazy var priceLabel: UILabel = {
         let label = UILabel()
         label.text = "$0.00"
         label.textAlignment = .right
         label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
         label.textColor = .exampleViewCellPrice
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
     
     private let loaderAnimationView: LottieAnimationView = {
         let animationView = LottieAnimationView(name: "Loader")
         animationView.loopMode = .loop
         animationView.translatesAutoresizingMaskIntoConstraints = false
         return animationView
     }()
     
     private var currentImageURL: String?

     override init(frame: CGRect) {
         super.init(frame: frame)

         setupViews()
         setConstraints()

     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     func setupViews() {
         addSubview(foodImageView)
         addSubview(loaderAnimationView)
         addSubview(backgroundTitleView)
         backgroundTitleView.addSubview(nameLabel)
         backgroundTitleView.addSubview(priceLabel)
     }

     func configureCell(imageURL: String, nameL: String, price: Int, isDataLoaded: Bool) {
             if isDataLoaded {
                 loaderAnimationView.isHidden = true
                 loaderAnimationView.stop()
             } else {
                 loaderAnimationView.isHidden = false
                 loaderAnimationView.play()
             }

             foodImageView.image = UIImage(named: "placeholder_image")

             if let url = URL(string: imageURL) {
                 foodImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
                     guard let self = self else { return }
                     self.loaderAnimationView.stop()
                     self.loaderAnimationView.isHidden = true
                 }
             }
             nameLabel.text = nameL
             priceLabel.text = "\(price) ₽"
         }

     
     func setConstraints() {
         NSLayoutConstraint.activate([

             foodImageView.topAnchor.constraint(equalTo: topAnchor),
             foodImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
             foodImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
             foodImageView.bottomAnchor.constraint(equalTo: backgroundTitleView.bottomAnchor,constant: 50),
             
             loaderAnimationView.centerXAnchor.constraint(equalTo: centerXAnchor),
             loaderAnimationView.centerYAnchor.constraint(equalTo: centerYAnchor),
             loaderAnimationView.widthAnchor.constraint(equalToConstant: 100),
             loaderAnimationView.heightAnchor.constraint(equalToConstant: 100),

             backgroundTitleView.bottomAnchor.constraint(equalTo: bottomAnchor),
             backgroundTitleView.leadingAnchor.constraint(equalTo: leadingAnchor),
             backgroundTitleView.trailingAnchor.constraint(equalTo: trailingAnchor),
             backgroundTitleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),

             nameLabel.centerYAnchor.constraint(equalTo: backgroundTitleView.centerYAnchor),
             nameLabel.leadingAnchor.constraint(equalTo: backgroundTitleView.leadingAnchor, constant: 16),
             nameLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8),
             nameLabel.widthAnchor.constraint(lessThanOrEqualTo: backgroundTitleView.widthAnchor, multiplier: 0.6),

             priceLabel.centerYAnchor.constraint(equalTo: backgroundTitleView.centerYAnchor),
             priceLabel.trailingAnchor.constraint(equalTo: backgroundTitleView.trailingAnchor, constant: -16)

         ])
     }
     deinit {
         print("ExampleCollectionViewCell deinitialized")
     }
 }
 final class APIManager {
         
     static let shared = APIManager()
     
     private func configureFB() -> Firestore {
         var db: Firestore!
         let settings = FirestoreSettings()
         Firestore.firestore().settings = settings
         db = Firestore.firestore()
         return db
     }

     func fetchFoodDataFromFirebase(foodItemKey: String, completion: @escaping ([MenuItem]?, Error?) -> Void) {
         let db = Firestore.firestore()
         db.collection(foodItemKey).getDocuments { snapshot, error in
             if let error = error {
                 completion(nil, error)
                 return
             }

             guard let snapshot = snapshot else {
                 completion(nil, nil)
                 return
             }

             var foodItems: [MenuItem] = []
             for document in snapshot.documents {
                 let data = document.data()
                 guard let title = data["title"] as? String,
                       let image = data["image"] as? String,
                       let price = data["price"] as? Int,
                       let categoryString = data["category"] as? String,
                       let category = FoodCategory(rawValue: categoryString),
                       let description = data["description"] as? String else {
                     continue
                 }

                 let foodItem = MenuItem(title: title,
                                         image: image,
                                         price: price,
                                         category: category,
                                         description: description)
                 foodItems.append(foodItem)
             }

             completion(foodItems, nil)
         }
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


 */

