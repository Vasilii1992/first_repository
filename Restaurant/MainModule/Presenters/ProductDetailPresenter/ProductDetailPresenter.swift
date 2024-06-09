import Foundation


class ProductDetailPresenter {
    private weak var view: ProductDetailViewProtocol?
    private var model: MockData
    private var category: FoodCategory?
    private var indexPath: IndexPath?

    init(view: ProductDetailViewProtocol, model: MockData, category: FoodCategory?, indexPath: IndexPath?) {
        self.view = view
        self.model = model
        self.category = category
        self.indexPath = indexPath
    }

    func getProductData() {
        view?.showLoadingAnimation()
        let filteredItems = model.foodForCategory.filter { $0.category == category }
        if let indexPath = indexPath, indexPath.row < filteredItems.count {
            let selectedItem = filteredItems[indexPath.row]
            if let url = URL(string: selectedItem.image) {
                view?.displayProduct(name: selectedItem.title, price: "\(selectedItem.price) ₽", imageUrl: url, description: selectedItem.description)
            }
        }
        view?.hideLoadingAnimation()
    }
}

