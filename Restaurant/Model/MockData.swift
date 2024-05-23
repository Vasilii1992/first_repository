

import Foundation

final class MockData {
    
    static let shared = MockData()
    
    private let sales: [MenuItem] = [
        .init(image: "IMG_7428"),
        .init(image: "IMG_7429"),
        .init(image: "IMG_7427"),
        .init(image: "IMG_7420"),
        .init(image: "IMG_7413"),
        .init(image: "IMG_7415"),
        .init(image: "IMG_7412"),
        .init(image: "IMG_7411")
        
    ]
    
    var foodForCategory: [MenuItem] = []

    private let categories: [FoodCategory] = [
        .salad, .soups, .hotDishes, .garnish, .burger, .pizza, .pasta, .dessert
    ]

    var pageData: [ListSection] {
        [
            .sales(sales),
            .category(categories.map {
                MenuItem(title: $0.title, image: $0.image, price: 0, category: $0, description: "")
            }),
            .foodForCategory(foodForCategory)
        ]
    }
}

/*

 */

