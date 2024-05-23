

import Foundation


final class FirebaseDrink {
    var subMenu: SubMenu
    var menu: [NameAndPrice]
    var isStatus: Bool

    var name: String
    var price: [VolumeAndPrice]
    var description: String
    var images: String
    
    init(subMenu: SubMenu, menu: [NameAndPrice], isStatus: Bool, name: String, price: [VolumeAndPrice], description: String, images: String) {
        self.subMenu = subMenu
        self.menu = menu
        self.isStatus = isStatus
        self.name = name
        self.price = price
        self.description = description
        self.images = images
    }
}

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

final class SubMenu {
    var subMenuName: String
    var subMenuImage: String
    
    init(subMenuName: String, subMenuImage: String) {
        self.subMenuName = subMenuName
        self.subMenuImage = subMenuImage
    }
}
