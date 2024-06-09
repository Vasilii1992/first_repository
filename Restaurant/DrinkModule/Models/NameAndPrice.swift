


final class NameAndPrice {
    var name: String
    var price: [VolumeAndPrice]
    var description: String
    var images: String
    
    init(name: String, price: [VolumeAndPrice], description: String, images: String) {
        self.name = name
        self.price = price
        self.description = description
        self.images = images
    }
}

struct VolumeAndPrice {
    var volume: String?
    var price: Int?
}
