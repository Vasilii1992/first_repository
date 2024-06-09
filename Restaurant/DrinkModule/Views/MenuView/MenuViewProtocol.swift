
import Foundation

protocol MenuViewProtocol: AnyObject {
    func showLoader()
    func hideLoader()
    func updateDrinkList(_ drinks: [FirebaseDrink])
    func showError(_ error: Error)
}
