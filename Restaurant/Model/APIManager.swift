
import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import Firebase

class APIManager {
        
    static let shared = APIManager()
    
    private func configureFB() -> Firestore {
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }    
}




