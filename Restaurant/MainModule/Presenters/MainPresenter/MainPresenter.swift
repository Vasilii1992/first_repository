
import UIKit
import Firebase

class MainPresenter {

    private weak var view: MainViewProtocol?
    private var sections: [ListSection] = []
    private var foodItemKey = "foodItemsEng".localized()

    var foodForCategory = MockData.shared.foodForCategory

    private var selectedCategory: FoodCategory? = .hotDishes
    
    init(view: MainViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        fetchFoodDataFromFirebase()
    }

    func fetchFoodDataFromFirebase() {
        view?.showLoader()
        APIManager.shared.fetchFoodDataFromFirebase(foodItemKey: foodItemKey) { [weak self] foodItems, error in
            guard let self = self else { return }

            if let error = error {
                self.view?.showError("Error getting documents: \(error)")
                self.view?.hideLoader()
                return
            }

            guard let foodItems = foodItems else {
                self.view?.showError("No documents found")
                self.view?.hideLoader()
                return
            }

            MockData.shared.foodForCategory = foodItems
            self.sections = MockData.shared.pageData
            self.view?.reloadCollectionView()
            self.view?.hideLoader()
        }
    }
}

