import UIKit

class HomeViewController: UIViewController {
    

    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var titleBarView: UIView!
    
//    lazy var addButton : UIButton = {
//        let button = UIButton()
//        return button
//    }()
    
    lazy var currentWeekLabel: UILabel = {
            let label = UILabel()
            label.text = "This Week"
            label.textColor = .gray
            label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            label.textAlignment = .left
            label.sizeToFit()
            return label
        }()
    
    lazy var totalAmountLabel: UILabel = {
            let label = UILabel()
            label.text = "Total:"
            label.textColor = .gray
            label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textAlignment = .left
            label.sizeToFit()
            return label
        }()
    
    lazy var totalExpenseAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGreen
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    var totalExpenseAmount: Double {
        // compute total amount here from your data source
        return 100.00 // for now, hardcoded
    }


        override func viewDidLoad() {
            super.viewDidLoad()


            view.addSubview(currentWeekLabel)
            view.addSubview(totalAmountLabel)
            view.addSubview(totalExpenseAmountLabel)

            categoryTableView.dataSource = self
            categoryTableView.estimatedRowHeight = 72
            categoryTableView.rowHeight = UITableView.automaticDimension
            categoryTableView.separatorStyle = .none
        }

        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()

            // Rounded bottom corners
            titleBarView.layer.cornerRadius = 20
            titleBarView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            titleBarView.clipsToBounds = true
            updateTotalExpenseLabel()
            currentWeekLabel.sizeToFit()
            totalAmountLabel.sizeToFit()
            totalExpenseAmountLabel.sizeToFit()
            
            totalAmountLabel.setContentHuggingPriority(.required, for: .horizontal)
            totalAmountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            totalExpenseAmountLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            totalExpenseAmountLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            
            addAllLabels()
            

            
    }
    

    func updateTotalExpenseLabel() {
        totalExpenseAmountLabel.text = "$\(String(format: "%.2f", totalExpenseAmount))"
        totalExpenseAmountLabel.sizeToFit()
    }

    
    func addAllLabels() {
        currentWeekLabel.sizeToFit()
        let xPosCurrentWeekLabel: CGFloat = 14
        let yPosCurrentWeekLabel: CGFloat = titleBarView.frame.maxY + 10
        currentWeekLabel.frame = CGRect(x: xPosCurrentWeekLabel,
                                        y: yPosCurrentWeekLabel,
                                        width: currentWeekLabel.frame.width,
                                        height: currentWeekLabel.frame.height)
        
        // Ensure labels have correct sizes
        totalAmountLabel.sizeToFit()
        totalExpenseAmountLabel.sizeToFit()
        
        // Calculate combined width
        let spacing: CGFloat = 5
        let totalLabelWidth = totalAmountLabel.frame.width
        let amountLabelWidth = totalExpenseAmountLabel.frame.width
        let totalCombinedWidth = totalLabelWidth + spacing + amountLabelWidth
        
        // Align to right
        let xPosTotalStart = view.frame.width - totalCombinedWidth - 14 // 14 for right padding
        let yPos = titleBarView.frame.maxY + 10
        let yPosTotalLabel = titleBarView.frame.maxY + 14

        totalAmountLabel.frame = CGRect(x: xPosTotalStart,
                                        y: yPosTotalLabel,
                                        width: totalLabelWidth,
                                        height: totalAmountLabel.frame.height)

        totalExpenseAmountLabel.frame = CGRect(x: totalAmountLabel.frame.maxX + spacing,
                                               y: yPos,
                                               width: amountLabelWidth,
                                               height: totalExpenseAmountLabel.frame.height)
    }

    
    


}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryExpenseTableViewCell.identifier, for: indexPath)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

