
final class MenuItem {
    let title: String
    let image: String
    let price: Int
    let description: String
    
    var category: FoodCategory = .dessert
    
    init(image: String) {
        self.title = ""
        self.image = image
        self.price = 0
        self.description = ""
    }
    
    init(title: String, image: String, price: Int, category: FoodCategory, description: String) {
        self.title = title
        self.image = image
        self.price = price
        self.category = category
        self.description = description
    }
}

