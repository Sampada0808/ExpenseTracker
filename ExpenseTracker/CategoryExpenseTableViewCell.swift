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
    
    func configure(with data: CategoryExpenseDataModel) {
        categoryIcon.image = data.icon.withRenderingMode(.alwaysTemplate)
        categoryIcon.tintColor = data.categoryName.color
        backgroundIconView.backgroundColor = data.categoryName.secondaryColor
        
        categoryName.text = data.categoryName.rawValue
        categoryName.textColor = data.categoryName.color
        categoryName.font = UIFont.style(.secondaryText)
        
        amountLabel.text = "$\(String(format: "%.2f", data.amount))"
        amountLabel.textColor = data.categoryName.color
        amountLabel.font = UIFont.style(.secondaryText)
    }


    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
