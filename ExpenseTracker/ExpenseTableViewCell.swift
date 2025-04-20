import UIKit

class ExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [costLabel, qtyLabel, itemLabel].forEach{
            $0?.font =  UIFont.style(.h3)
        }
    }
    
    func configure(with item: ExpenseItem) {
        itemLabel.text = item.item
        qtyLabel.text = "\(item.qty) \(item.unit)"
        costLabel.text = String(format: "%.2f", item.price)
    }


    
}
