import UIKit

class CustomHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var firstLeftLine: UIView!
    @IBOutlet weak var secondRightLine: UIView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Check if outlets are nil
        contentView.backgroundColor = UIColor.lightGreen
        // Initialization code
    }
    
    func localizedCurrencyString(from amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current // Automatically picks user's locale
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    func totalExpense(from dailyExpenses: [DailyExpense]) -> Double {
        return dailyExpenses.flatMap { $0.item }.reduce(0) { $0 + $1.price }
    }

    func localizedTotalString(from dailyExpenses: [DailyExpense]) -> String {
        let total = totalExpense(from: dailyExpenses)
        return localizedCurrencyString(from: total)
    }


    
    func settingLabelStyles(){
        firstLabel.font = UIFont.style(.body)
        secondLabel.font = UIFont.style(.body)
        thirdLabel.font = UIFont.style(.body)
        
    }
    
    func configure(with expense: ExpenseItem, category: Category) {
        print("Printing\(expense.item)")
        firstLabel.text = expense.item
        secondLabel.text = "\(expense.qty) \(expense.unit)"
        thirdLabel.text = localizedCurrencyString(from: expense.price)

        bottomLine.isHidden = true
        firstLeftLine.backgroundColor = .clear
        secondRightLine.backgroundColor = .clear

        [firstLabel, secondLabel, thirdLabel].forEach {
            $0?.font = UIFont.style(.secondaryText)
            $0?.textColor = category.color
        }
    }

    func setHeader(){
        topLine.isHidden  = true
        bottomLine.isHidden =  true
        firstLabel.text = "Item"
        secondLabel.text =  "Qty"
        thirdLabel.text = "Amount"
        settingLabelStyles()
    }
    
    func setFooter(with dailyExpense: DailyExpense) {
        let total = dailyExpense.item.reduce(0) { $0 + $1.price }
        let totalString = localizedCurrencyString(from: total)

        firstLeftLine.backgroundColor = .clear
        firstLabel.textColor = .clear
        secondLabel.text = "Amount :"
        thirdLabel.text = totalString
        bottomLine.backgroundColor = .clear
        firstLeftLine.backgroundColor = .clear

        [secondLabel, thirdLabel].forEach {
            $0?.textColor = UIColor.darkGreen
        }

        settingLabelStyles()
    }


    
}
