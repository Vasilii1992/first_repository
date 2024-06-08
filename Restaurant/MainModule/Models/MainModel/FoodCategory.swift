
import Foundation

enum FoodCategory: String {
    case burger = "Burgers"
    case pizza = "Pizza"
    case pasta = "Pasta"
    case soups = "Soups"
    case hotDishes = "Main dishes"
    case dessert = "Desserts"
    case salad = "Salads"
    case garnish = "Garnish"

    var title: String {
        switch self {
        case .burger:    return "Burger".localized()
        case .pizza:     return "Pizza".localized()
        case .pasta:     return "Pasta".localized()
        case .soups:     return "Soups".localized()
        case .hotDishes: return "Main".localized()
        case .dessert:   return "Dessert".localized()
        case .salad:     return "Salads".localized()
        case .garnish:   return "Garnish".localized()
        }
    }

    var image: String {
        switch self {
        case .burger: return "burgerIcon"
        case .pizza: return "pizzaIcon"
        case .pasta: return "pastaIcon2"
        case .soups: return "soupIcon"
        case .hotDishes: return "mainDishIcon2"
        case .dessert: return "cakeIcon"
        case .salad: return "fsalad"
        case .garnish: return "garnirIcon"
        }
    }
}

