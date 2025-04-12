import UIKit

class HomeViewController: UIViewController {
    

    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var titleBarView: UIView!
    
    var categoricalExpenses: [CategoryExpenseDataModel] = [
       CategoryExpenseDataModel(icon: UIImage(named: "Fruits")!, categoryName: .fruits , amount: 500.00),CategoryExpenseDataModel(icon: UIImage(named: "Groceries")!, categoryName: .groceries, amount: 100.55)
        ]

    lazy var noExpenseLabel : UILabel = {
        let label = UILabel()
        label.text = "No Expense added yet"
        label.font = UIFont.style(.messageLabel)
        label.textColor = UIColor.grassGreen
        return label
    }()
    
    lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.text = "Tap + to add a new expense"
        label.font = UIFont.style(.instructionLabel)
        label.textColor = UIColor.mediumGreen
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.secondaryMediumGreen.withAlphaComponent(0.2)
        button.tintColor = UIColor.MediumGreen
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.layer.transform = CATransform3DMakeScale(3, 3, 3)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()

    
    @objc func addButtonTapped(){
        let newExpenseModalController = NewExpenseModalViewController()
        present(newExpenseModalController, animated: true)
        
    }
    
    
    
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
        return categoricalExpenses.reduce(0) { $0 + $1.amount }
    }


        override func viewDidLoad() {
            super.viewDidLoad()
            


            view.addSubview(currentWeekLabel)
            view.addSubview(totalAmountLabel)
            view.addSubview(totalExpenseAmountLabel)
            view.addSubview(addButton)
            view.addSubview(noExpenseLabel)
            view.addSubview(messageLabel)

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
            
            let buttonSize: CGFloat = 60
            let xPos = (view.frame.width - buttonSize) / 2
            let yPos = view.frame.height - buttonSize - 40
            addButton.frame = CGRect(x: xPos, y: yPos, width: buttonSize, height: buttonSize)
            addButton.layer.cornerRadius = buttonSize / 2
            
            titleBarView.layer.shadowColor = UIColor.black.cgColor
            titleBarView.layer.shadowOpacity = 0.2
            titleBarView .layer.shadowRadius = 5
            titleBarView.layer.shadowOffset = CGSize(width: 0, height: 5)
            titleBarView.layer.masksToBounds = false
            
            addButton.layer.shadowColor = UIColor.black.cgColor
            addButton.layer.shadowRadius = 5
            addButton.layer.shadowOpacity = 0.4
            addButton.layer.shadowOffset = CGSize(width: 4, height: 4)
            addButton.layer.masksToBounds = false

            
    }
    

    func updateTotalExpenseLabel() {
        totalExpenseAmountLabel.text = "$\(String(format: "%.2f", totalExpenseAmount))"
        totalExpenseAmountLabel.sizeToFit()
    }

    
    func addAllLabels() {
        let total = totalExpenseAmount
        
        if categoricalExpenses.isEmpty ||  total == 0{
            noExpenseLabel.isHidden = false
            messageLabel.isHidden = false
            totalExpenseAmountLabel.isHidden = true
            totalAmountLabel.isHidden = true
            currentWeekLabel.isHidden = true


            noExpenseLabel.sizeToFit()
            let xPosExpenseLabel = (view.frame.width - noExpenseLabel.frame.width) / 2
            let yPosExpenseLabel = (view.frame.height - noExpenseLabel.frame.height) / 2 - 50
            noExpenseLabel.frame = CGRect(x: xPosExpenseLabel,
                                           y: yPosExpenseLabel,
                                           width: noExpenseLabel.frame.width,
                                           height: noExpenseLabel.frame.height)

            messageLabel.sizeToFit()
            let xPosMessageLabel = (view.frame.width - messageLabel.frame.width) / 2
            let yPosMessageLabel = noExpenseLabel.frame.maxY + 40
            messageLabel.frame = CGRect(x: xPosMessageLabel,
                                         y: yPosMessageLabel,
                                         width: messageLabel.frame.width / 2 + 100 ,
                                         height: messageLabel.frame.height)
        } else {
            // Hide all when expenses exist
            noExpenseLabel.isHidden = true
            messageLabel.isHidden = true
            totalExpenseAmountLabel.isHidden = false
            totalAmountLabel.isHidden = false
            currentWeekLabel.isHidden = false
            
            currentWeekLabel.sizeToFit()
            let xPosCurrentWeekLabel: CGFloat = 14
            let yPosCurrentWeekLabel: CGFloat = titleBarView.frame.maxY + 14
            currentWeekLabel.frame = CGRect(x: xPosCurrentWeekLabel,
                                            y: yPosCurrentWeekLabel,
                                            width: currentWeekLabel.frame.width,
                                            height: currentWeekLabel.frame.height)
            
            totalAmountLabel.sizeToFit()
            totalExpenseAmountLabel.sizeToFit()

            let spacing: CGFloat = 5
            let totalLabelWidth = totalAmountLabel.frame.width
            let amountLabelWidth = totalExpenseAmountLabel.frame.width
            let totalCombinedWidth = totalLabelWidth + spacing + amountLabelWidth

            let xPosTotalStart = view.frame.width - totalCombinedWidth - 14
            let yPos = titleBarView.frame.maxY + 14
            let yPosTotalLabel = titleBarView.frame.maxY + 18

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

    
    


}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = categoricalExpenses[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryExpenseTableViewCell.identifier, for: indexPath) as? CategoryExpenseTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: detail) // <-- configure the cell
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoricalExpenses.count
    }
}


