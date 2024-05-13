
import Foundation


enum ListSection {
    case sales([MenuItem])
    case category([MenuItem])
    case foodForCategory([MenuItem])
    
    var items: [MenuItem] {
        switch self {
        case .sales(let items):
            return items
        case .category(let items):
            return items
        case .foodForCategory(let items):
            return items
        }
    }
    
    var count: Int  {
        items.count
    }
    var title: String {
        switch self {
            
        case .sales(_):
            return ""
        case .category(_):
            return "Categories".localized()
        case .foodForCategory(_):
            return Resources.Strings.foodForCategory
        }
    }    
}

