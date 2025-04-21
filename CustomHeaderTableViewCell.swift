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
    
    func settingLabelStyles(){
        firstLabel.font = UIFont.style(.body)
        secondLabel.font = UIFont.style(.body)
        thirdLabel.font = UIFont.style(.body)
        
    }
    
    func configure(with expense: ExpenseItem) {
        firstLabel.text = expense.item
        secondLabel.text = "\(expense.qty) \(expense.unit)"
        thirdLabel.text = "₹\(expense.price)"
        bottomLine.isHidden =  true
        [firstLabel,secondLabel,thirdLabel].forEach {
            $0?.font = UIFont.style(.secondaryText)
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
    
    func setFooter(){
        firstLeftLine.backgroundColor = .clear
        firstLabel.textColor = .clear
        secondLabel.text =  "Amount : "
        thirdLabel.text = "$700.00"
        bottomLine.backgroundColor =  .clear
        firstLeftLine.backgroundColor = .clear
        [secondLabel,thirdLabel].forEach {
            $0?.textColor = UIColor.darkGreen
        }
        settingLabelStyles()
    }
    
}
