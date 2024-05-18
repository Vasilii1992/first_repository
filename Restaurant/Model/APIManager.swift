
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestoreInternal
import FirebaseFirestore

final class APIManager {
        
    static let shared = APIManager()
    
    private func configureFB() -> Firestore {
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }

    func fetchFoodDataFromFirebase(foodItemKey: String, completion: @escaping ([MenuItem]?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection(foodItemKey).getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let snapshot = snapshot else {
                completion(nil, nil)
                return
            }

            var foodItems: [MenuItem] = []
            for document in snapshot.documents {
                let data = document.data()
                guard let title = data["title"] as? String,
                      let image = data["image"] as? String,
                      let price = data["price"] as? Int,
                      let categoryString = data["category"] as? String,
                      let category = FoodCategory(rawValue: categoryString),
                      let description = data["description"] as? String else {
                    continue
                }

                let foodItem = MenuItem(title: title,
                                        image: image,
                                        price: price,
                                        category: category,
                                        description: description)
                foodItems.append(foodItem)
            }

            completion(foodItems, nil)
        }
    }
    
    
    
    
    func fetchDrinksData(collectionName: String, completion: @escaping ([FirebaseDrink]?, Error?) -> Void) {
            let db = Firestore.firestore()
            db.collection(collectionName).getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                guard let snapshot = snapshot else {
                    completion(nil, nil)
                    return
                }

                var drinks: [FirebaseDrink] = []
                for document in snapshot.documents {
                    let data = document.data()
                    guard let subMenuName = data["subMenuName"] as? String,
                          let subMenuImage = data["subMenuImage"] as? String,
                          let drinksData = data["menu"] as? [[String: Any]] else {
                        continue
                    }

                    var menu: [NameAndPrice] = []
                    for drinkData in drinksData {
                        guard let name = drinkData["name"] as? String,
                              let description = drinkData["description"] as? String,
                              let images = drinkData["images"] as? String,
                              let priceData = drinkData["price"] as? [[String: Any]] else {
                            continue
                        }

                        var volumeAndPrices: [VolumeAndPrice] = []
                        for priceEntry in priceData {
                            guard let volume = priceEntry["volume"] as? String,
                                  let price = priceEntry["price"] as? Int else {
                                continue
                            }
                            let volumeAndPrice = VolumeAndPrice(volume: volume, price: price)
                            volumeAndPrices.append(volumeAndPrice)
                        }

                        let drink = NameAndPrice(name: name,
                                                 price: volumeAndPrices,
                                                 description: description,
                                                 images: images)
                        menu.append(drink)
                    }

                    let subMenu = SubMenu(subMenuName: subMenuName, subMenuImage: subMenuImage)
                    let firebaseDrink = FirebaseDrink(subMenu: subMenu,
                                                      menu: menu,
                                                      isStatus: false,
                                                      name: subMenuName,
                                                      price: [],
                                                      description: "",
                                                      images: subMenuImage)
                    drinks.append(firebaseDrink)
                }

                completion(drinks, nil)
        }
    }
}
