import Foundation
import UIKit

struct ExpenseItem{
    let item : String
    let qty : String
    let unit : String
    let price : Double
}

struct DailyExpense {
    let date : Date
    let category : Category
    let item : [ExpenseItem]
}


struct CategoryExpenseDataModel {
    let icon: UIImage
    let categoryName: Category
    let amount: Double
}



