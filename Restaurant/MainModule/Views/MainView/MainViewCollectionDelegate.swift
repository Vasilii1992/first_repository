
import UIKit

extension MainView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.ReuseIdentifierForMainView.saleId, for: indexPath) as! SaleCollectionViewCell
               cell.configureCell(imageNames: sale.map { $0.image })
               return cell
           case .foodForCategory:
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.ReuseIdentifierForMainView.exampleId, for: indexPath) as! ExampleCollectionViewCell
               let filteredItems = MockData.shared.foodForCategory.filter { $0.category == selectedCategory }
               let foodItem = filteredItems[indexPath.row]
               cell.configureCell(imageURL: foodItem.image, nameL: foodItem.title, price: foodItem.price, isDataLoaded: true)
               return cell
           case .category(let category):
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.ReuseIdentifierForMainView.categoryId, for: indexPath) as! CategoryCollectionViewCell
               cell.configureCell(categoryName: category[indexPath.row].title, imageName: category[indexPath.row].image)
               return cell
           }
       }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: Resources.ReuseIdentifierForMainView.headerId,
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
