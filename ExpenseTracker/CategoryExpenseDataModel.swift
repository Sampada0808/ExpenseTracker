import Foundation
import UIKit

struct ExpenseItem: Identifiable {
    let id: UUID  // Unique identifier for each expense item
    var item: String
    var qty: String
    var unit: String
    var price: Double
    
    // Init to auto-generate UUID
    init(id: UUID = UUID(), item: String, qty: String, unit: String, price: Double) {
        self.id = id
        self.item = item
        self.qty = qty
        self.unit = unit
        self.price = price
    }
}


struct DailyExpense: Identifiable {
    let id: UUID  // ✅ Unique identifier
    var date: Date
    var category: Category
    var item: [ExpenseItem]
    
    // Init to auto-generate UUID
    init(id: UUID = UUID(), date: Date, category: Category, item: [ExpenseItem]) {
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
