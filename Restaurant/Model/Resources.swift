
import Foundation


enum Resources {
    enum Links {
        static var privacyPolicy = "https://policyforrestaurant.tilda.ws/policyforrestaurant"
        
    }
    
    enum Fonts {
        static var palatinoItalic = "Palatino Italic"
        static var snellRoundhandBold = "Snell Roundhand Bold"
        static var timesNewRoman = "Times New Roman"
        static var noteworthyLight = "Noteworthy Light"
    }
    
    enum Strings {
        
        enum CustomSegmentedControl {
            static var alcohol = "Alcohol".localized()
            static var nonAlcohol = "Non-Alcoholic".localized()
        }
        
        enum TabBarTitle {
            
            static var food = "Food".localized()
           static var drink = "Drinks".localized()
           static var aboutUS = "About Us".localized()
            
        }
        static let foodForCategory = "Dishes of the Category".localized()
        static var informationLabel = "Our Restaurant \nis located in the \nMoskovskie Vorota Hotel \nat the address: \nMoskovsky prospekt 97A.\nWe will be glad \nto see you.".localized()
        static var phoneLabel = "Phone: 8(812)448-71-21"
        static var privacyPolicy = "Privacy Policy"
    }
}
