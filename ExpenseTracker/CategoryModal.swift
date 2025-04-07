//
//  CategoryModal.swift
//  ExpenseTracker
//
//  Created by Sampada Shankar on 07/04/25.
//

import Foundation
import UIKit

enum Category : String, CaseIterable{
    case medicine = "Medicine", doctor = "Doctor", groceries = "Groceries", fruit = "Fruits", vegetables = "Vegetables", misc = "Miscellaneous", online = "Online", snacks = "Snacks"
    
    var color : UIColor {
        switch self{
        case .doctor : return UIColor.doctor
        case .medicine:  return UIColor.medicine
        case .groceries:  return UIColor.groceries
        case .fruit:  return UIColor.fruits
        case .vegetables:  return UIColor.vegetable
        case .misc:  return UIColor.miscellaneous
        case .online:  return UIColor.online
        case .snacks:  return UIColor.snacks
        }
    }
    
    var secondaryColor : UIColor {
        switch self{
        case .doctor : return UIColor.backgroundDoctors
        case .medicine:  return UIColor.backgroundMedicines
        case .groceries:  return UIColor.backgroundGroceries
        case .fruit:  return UIColor.backgroundFruit
        case .vegetables:  return UIColor.backgroundVegetables
        case .misc:  return UIColor.backgroundMisc
        case .online:  return UIColor.backgroundOnlines
        case .snacks:  return UIColor.backgroundSnack
        }
    }
    
}
