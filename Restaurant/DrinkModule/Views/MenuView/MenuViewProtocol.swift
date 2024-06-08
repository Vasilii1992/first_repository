//
//  MenuViewProtocol.swift
//  Restaurant
//
//  Created by Василий Тихонов on 08.06.2024.
//

import Foundation

protocol MenuViewProtocol: AnyObject {
    func showLoader()
    func hideLoader()
    func updateDrinkList(_ drinks: [FirebaseDrink])
    func showError(_ error: Error)
}
