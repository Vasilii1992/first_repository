
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
    func fetchFoodDataFromFirebase() {
        DispatchQueue.main.async {
            self.loaderAnimationView.isHidden = false
            self.loaderAnimationView.play()
        }

        let db = Firestore.firestore()
        db.collection(foodItemKey).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }

            // Processing data fetch on a background thread
            DispatchQueue.global(qos: .userInitiated).async {
                if let error = error {
                    DispatchQueue.main.async {
                        print("Error getting documents: \(error)")
                        self.loaderAnimationView.stop()
                        self.loaderAnimationView.isHidden = true
                    }
                    return
                }

                guard let snapshot = snapshot else {
                    DispatchQueue.main.async {
                        print("No documents found")
                        self.loaderAnimationView.stop()
                        self.loaderAnimationView.isHidden = true
                    }
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

                // Updating shared data store on background thread
                MockData.shared.foodForCategory = foodItems

                // Updating UI on main thread
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.loaderAnimationView.stop()
                    self.loaderAnimationView.isHidden = true
                }
            }
        }
    }


//    func fetchFoodDataFromFirebase() {
//        loaderAnimationView.isHidden = false
//        loaderAnimationView.play()
//        let db = Firestore.firestore()
//        db.collection(foodItemKey).getDocuments { [weak self] snapshot, error in
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
//            guard let snapshot = snapshot else {
//                print("No documents found")
//                return
//            }
//
//            var foodItems: [MenuItem] = []
//            for document in snapshot.documents {
//                let data = document.data()
//                guard let title = data["title"] as? String,
//                      let image = data["image"] as? String,
//                      let price = data["price"] as? Int,
//                      let categoryString = data["category"] as? String,
//                      let category = FoodCategory(rawValue: categoryString),
//                      let description = data["description"] as? String else {
//                    continue
//                }
//
//                let foodItem = MenuItem(title: title,
//                                        image: image,
//                                        price: price,
//                                        category: category,
//                                        description: description)
//                foodItems.append(foodItem)
//            }
//            MockData.shared.foodForCategory = foodItems
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
//    }

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
                                     interGroupSpasing: CGFloat,
                                     supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem],
                                     contentInsers: Bool) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = behavior
        section.interGroupSpacing = interGroupSpasing
        section.boundarySupplementaryItems = supplementaryItems
        section.supplementariesFollowContentInsets = contentInsers

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
                                          interGroupSpasing: 5,
                                          supplementaryItems: [],
                                          contentInsers: false)
            section.contentInsets = .init(top: -60, leading: 0, bottom: 0, trailing: 0)
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
                                          interGroupSpasing: 10,
                                          supplementaryItems: [suplementaryHeaderItem()],
                                          contentInsers: false)
            section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        
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
                                          interGroupSpasing: 10,
                                          supplementaryItems: [suplementaryHeaderItem()],
                                          contentInsers: false)
            section.contentInsets = .init(top: -85, leading: 10, bottom: 0, trailing: 0)
        
        return section
    }
    
    
    
    private func suplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                heightDimension: .estimated(30)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top)
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
