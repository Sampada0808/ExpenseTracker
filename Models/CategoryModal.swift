import Foundation
import UIKit
import RealmSwift

enum Category: String, CaseIterable, PersistableEnum {
    case medicine = "Medicine"
    case doctor = "Doctor"
    case groceries = "Groceries"
    case fruits = "Fruits"
    case vegetables = "Vegetables"
    case miscellaneous = "Miscellaneous"
    case online = "Online"
    case snacks = "Snacks"
    
    var color: UIColor {
        switch self {
        case .doctor: return UIColor.doctors
        case .medicine: return UIColor.medicines
        case .groceries: return UIColor.grocerie
        case .fruits: return UIColor.fruit
        case .vegetables: return UIColor.vegetables
        case .miscellaneous: return UIColor.misc
        case .online: return UIColor.onlines
        case .snacks: return UIColor.snack
        }
    }

    var secondaryColor: UIColor {
        switch self {
        case .doctor: return UIColor.backgroundDoctors
        case .medicine: return UIColor.backgroundMedicines
        case .groceries: return UIColor.backgroundGroceries
        case .fruits: return UIColor.backgroundFruit
        case .vegetables: return UIColor.backgroundVegetables
        case .miscellaneous: return UIColor.backgroundMisc
        case .online: return UIColor.backgroundOnlines
        case .snacks: return UIColor.backgroundSnack
        }
    }
    
    var image : UIImage {
        switch self{
        case .medicine: return UIImage.medicine
        case .doctor: return UIImage.doctor
        case .groceries: return UIImage.groceries
        case .fruits: return UIImage.fruits
        case .vegetables: return UIImage.vegetable
        case .miscellaneous: return UIImage.miscellaneous
        case .online: return UIImage.online
        case .snacks: return UIImage.snacks
        }
    }
}
