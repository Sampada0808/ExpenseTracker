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
        backgroundIconView.backgroundColor = UIColor(named: "Medicine")?.withAlphaComponent(0.5)
        backgroundIconView.contentMode = .scaleAspectFit
        
        categoryCellView.layer.shadowColor = UIColor.black.cgColor
        categoryCellView.layer.shadowOpacity = 0.5 // nice soft shadow
        categoryCellView.layer.shadowOffset = CGSize(width: 0, height: 4) // pushes shadow downward
        categoryCellView.layer.shadowRadius = 4
        categoryCellView.layer.masksToBounds = false
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
