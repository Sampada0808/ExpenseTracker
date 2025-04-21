import UIKit

class CategoryExpenseTableViewCell: UITableViewCell {
    static let identifier = "ExpenseTable"

    @IBOutlet weak var backgroundIconView: UIView!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryCellView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundIconView.layoutIfNeeded()
        categoryCellView.layer.cornerRadius = CGFloat(30)
        
        backgroundIconView.layer.cornerRadius = backgroundIconView.frame.height / 2
        backgroundIconView.clipsToBounds = true
        backgroundIconView.contentMode = .scaleAspectFit
        
        categoryCellView.layer.shadowColor = UIColor.black.cgColor
        categoryCellView.layer.shadowOpacity = 0.5 // nice soft shadow
        categoryCellView.layer.shadowOffset = CGSize(width: 0, height: 4) 
        categoryCellView.layer.shadowRadius = 4
        categoryCellView.layer.masksToBounds = false
    }
    
    func configure(with model: CategoryExpenseDataModel) {
        // Set the icon image
        categoryIcon.image = model.icon.withRenderingMode(.alwaysTemplate)
        
        // Set the tint color based on the category's primary color
        categoryIcon.tintColor = model.categoryName.color
        
        // Set the background color of the icon view based on the category's secondary color
        backgroundIconView.backgroundColor = model.categoryName.secondaryColor
        
        // Set the category name and apply its color
        categoryName.text = model.categoryName.rawValue
        categoryName.textColor = model.categoryName.color
        categoryName.font = UIFont.style(.secondaryText)
        
        // Format and set the amount
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        if let formattedAmount = formatter.string(from: NSNumber(value: model.amount)) {
            amountLabel.text = formattedAmount
        } else {
            amountLabel.text = "\(model.amount)" // fallback, just in case
        }

        amountLabel.textColor = model.categoryName.color
        amountLabel.font = UIFont.style(.secondaryText)
    }


    
//    func configure(with data: CategoryExpenseDataModel) {
//        categoryIcon.image = data.icon.withRenderingMode(.alwaysTemplate)
//        categoryIcon.tintColor = data.categoryName.color
//        backgroundIconView.backgroundColor = data.categoryName.secondaryColor
//        
//        categoryName.text = data.categoryName.rawValue
//        categoryName.textColor = data.categoryName.color
//        categoryName.font = UIFont.style(.secondaryText)
//        
//        amountLabel.text = "$\(String(format: "%.2f", data.amount))"
//        amountLabel.textColor = data.categoryName.color
//        amountLabel.font = UIFont.style(.secondaryText)
//    }


    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
