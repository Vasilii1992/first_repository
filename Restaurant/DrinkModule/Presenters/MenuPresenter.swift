

import Foundation

protocol MenuPresenterProtocol {
    func viewDidLoad()
    func fetchData(selectedIndex: Int)
}

final class MenuPresenter: MenuPresenterProtocol {
    private weak var view: MenuViewProtocol?
    private let apiManager: APIManager
    
    init(view: MenuViewProtocol, apiManager: APIManager = .shared) {
        self.view = view
        self.apiManager = apiManager
    }
    
    func viewDidLoad() {
        fetchData(selectedIndex: 0)
    }
    
    func fetchData(selectedIndex: Int) {
        view?.showLoader()
        let collectionName = selectedIndex == 0 ? "alcoEng".localized() : "notAlcoEng".localized()
        
        apiManager.fetchDrinksData(collectionName: collectionName) { [weak self] drinks, error in
            guard let self = self else { return }
            self.view?.hideLoader()
            
            if let error = error {
                self.view?.showError(error)
                return
            }
            
            guard let drinks = drinks else {
                
                return
            }
            
            self.view?.updateDrinkList(drinks)
        }
    }
}
