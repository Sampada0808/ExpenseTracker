import Foundation
import UIKit
import RealmSwift

struct ExpenseItem: Identifiable {
    let id: String
    var item: String
    var qty: String
    var unit: String
    var price: Double
    
    init(id: String = UUID().uuidString, item: String, qty: String, unit: String, price: Double) {
        self.id = id
        self.item = item
        self.qty = qty
        self.unit = unit
        self.price = price
    }
}


struct DailyExpense: Identifiable {
    let id: String
    var date: Date
    var category: Category
    var item: [ExpenseItem]
    
    init(id: String = UUID().uuidString, date: Date, category: Category, item: [ExpenseItem]) {
        self.id = id
        self.date = date
        self.category = category
        self.item = item
    }
    
}

struct CategoryExpenseDataModel {
    let icon: UIImage
    let categoryName: Category
    let amount: Double
}


class LocalExpenseItem : Object{
    @Persisted(primaryKey: true) var _id : String
    @Persisted var item = ""
    @Persisted var qty = ""
    @Persisted var price = 0.0
    @Persisted var unit = ""
    
}

class LocalDailyExpense : Object{
    @Persisted(primaryKey: true) var _id : String
    @Persisted var date =  Date()
    @Persisted var category = Category.doctor
    @Persisted var item = List<LocalExpenseItem>()
    
}


