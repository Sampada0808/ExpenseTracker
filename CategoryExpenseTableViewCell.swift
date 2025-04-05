import UIKit

class CategoryExpenseTableViewCell: UITableViewCell {
    static let identifier = "ExpenseTable"

    @IBOutlet weak var backgroundIconView: UIView!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundIconView.layer.cornerRadius = backgroundIconView.frame.height / 2
        backgroundIconView.clipsToBounds = true
        backgroundIconView.backgroundColor = UIColor(named: "Medicine")?.withAlphaComponent(0.5)
        backgroundIconView.contentMode = .scaleAspectFit
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
