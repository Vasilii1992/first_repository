

import Foundation

protocol ProductDetailViewProtocol: AnyObject {
    func displayProduct(name: String, price: String, imageUrl: URL, description: String)
    func showLoadingAnimation()
    func hideLoadingAnimation()
}

