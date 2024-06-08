
import Foundation

protocol MainViewProtocol: AnyObject {
    func showLoader()
    func hideLoader()
    func reloadCollectionView()
    func showError(_ error: String)
    func presentProductDetailViewController(_ selectedProduct: MenuItem, indexPath: IndexPath)
    
}
