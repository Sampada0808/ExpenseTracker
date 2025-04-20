import UIKit

class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var categoryTableView: UITableView!
    var titleBarView: UIView!
    
    // MARK: - Data Sources
    var categoricalExpenses: [CategoryExpenseDataModel] = [
        CategoryExpenseDataModel(icon: Category.medicine.image, categoryName: .medicine, amount: 350),
        CategoryExpenseDataModel(icon: Category.doctor.image, categoryName: .doctor, amount: 800),
        CategoryExpenseDataModel(icon: Category.groceries.image, categoryName: .groceries, amount: 1200),
        CategoryExpenseDataModel(icon: Category.snacks.image, categoryName: .snacks, amount: 150)
    ]
    var dailyExpense: [DailyExpense] =  [
        DailyExpense(
            date: Date(),
            category: .medicine,
            item: [
                ExpenseItem(item: "Paracetamol", qty: "2", unit: "Strips", price: 100),
                ExpenseItem(item: "Bandage", qty: "1", unit: "Pack", price: 50),
                ExpenseItem(item: "Cough Syrup", qty: "1", unit: "Bottle", price: 200)
            ]
        ),
        DailyExpense(
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            category: .groceries,
            item: [
                ExpenseItem(item: "Rice", qty: "2", unit: "Kg", price: 180),
                ExpenseItem(item: "Pulses", qty: "1", unit: "Kg", price: 120),
                ExpenseItem(item: "Oil", qty: "1", unit: "L", price: 150)
            ]
        ),
        DailyExpense(
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            category: .doctor,
            item: [
                ExpenseItem(item: "Consultation", qty: "1", unit: "Visit", price: 800)
            ]
        ),
        DailyExpense(
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            category: .snacks,
            item: [
                ExpenseItem(item: "Chips", qty: "3", unit: "Packets", price: 90),
                ExpenseItem(item: "Cookies", qty: "1", unit: "Box", price: 60)
            ]
        )
    ]
    



        
    
    // MARK: - Computed Property
    var totalExpenseAmount: Double {
        return categoricalExpenses.reduce(0) { $0 + $1.amount }
    }
    
    // MARK: - UI Components
    
    // Labels for empty state
    lazy var noExpenseLabel: UILabel = {
        let label = UILabel()
        label.text = "No Expense added yet"
        label.font = UIFont.style(.messageLabel)
        label.textColor = UIColor.grassGreen
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.text = "Tap + to add a new expense"
        label.font = UIFont.style(.instructionLabel)
        label.textColor = UIColor.mediumGreen
        return label
    }()
    
    // Add button
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
    
    // Labels for total expense
    lazy var currentWeekLabel: UILabel = {
        let label = UILabel()
        label.text = "This Week"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Total:"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var totalExpenseAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGreen
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib  =  NavBarViewController(nibName: "NavBarViewController", bundle: nil)
        addChild(nib)
        self.titleBarView = nib.view
        
        // Observer for new expense added
        NotificationCenter.default.addObserver(self, selector: #selector(handleExpense), name: NSNotification.Name("com.Spendly.addExpense"), object: nil)

        // Setup views
        view.addSubview(currentWeekLabel)
        view.addSubview(totalAmountLabel)
        view.addSubview(totalExpenseAmountLabel)
        view.addSubview(addButton)
        view.addSubview(noExpenseLabel)
        view.addSubview(messageLabel)
        view.addSubview(titleBarView)


        // Setup TableView
        categoryTableView.dataSource = self
        categoryTableView.estimatedRowHeight = 72
        categoryTableView.rowHeight = UITableView.automaticDimension
        categoryTableView.separatorStyle = .none

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        titleBarView.applyCardStyle()
        titleBarView.pinToTop(of: self.view)
        categoryTableView.tableViewConstraints(for: self.view, from: titleBarView)

        
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowOpacity = 0.2
        addButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        addButton.layer.masksToBounds = false
        
        // Add button position and round
        let buttonSize: CGFloat = 60
        let xPos = (view.frame.width - buttonSize) / 2
        let yPos = view.frame.height - buttonSize - 40
        addButton.frame = CGRect(x: xPos, y: yPos, width: buttonSize, height: buttonSize)
        addButton.layer.cornerRadius = buttonSize / 2

        updateTotalExpenseLabel()
        addAllLabels()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    @objc func addButtonTapped() {
        let newExpenseModalController = NewExpenseModalViewController()
        present(newExpenseModalController, animated: true)
    }
    
    @objc func handleExpense(_ notification: Notification) {
        if let dailyExpenses = notification.userInfo?["newExpense"] as? DailyExpense {
            dailyExpense.append(dailyExpenses)

            // Recalculate summary
            categoricalExpenses = generateCategoryDataModels(from: dailyExpense)
            
            // Update UI
            categoryTableView.reloadData()
            addAllLabels()
            updateTotalExpenseLabel()
        }
    }

    
    // MARK: - Helpers
    
    /// Update total expense label text
    func updateTotalExpenseLabel() {
        totalExpenseAmountLabel.text = "$\(String(format: "%.2f", totalExpenseAmount))"
        totalExpenseAmountLabel.sizeToFit()
    }
    
    /// Show or hide labels based on expense data
    func addAllLabels() {
        let total = totalExpenseAmount
        
        if categoricalExpenses.isEmpty || total == 0 {
            // Empty state UI
            noExpenseLabel.isHidden = false
            messageLabel.isHidden = false
            totalExpenseAmountLabel.isHidden = true
            totalAmountLabel.isHidden = true
            currentWeekLabel.isHidden = true
            
            // Center labels
            noExpenseLabel.sizeToFit()
            noExpenseLabel.frame.origin = CGPoint(
                x: (view.frame.width - noExpenseLabel.frame.width) / 2,
                y: (view.frame.height - noExpenseLabel.frame.height) / 2 - 50
            )

            messageLabel.sizeToFit()
            messageLabel.frame = CGRect(
                x: (view.frame.width - messageLabel.frame.width) / 2,
                y: noExpenseLabel.frame.maxY + 40,
                width: messageLabel.frame.width / 2 + 100,
                height: messageLabel.frame.height
            )
        } else {
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
    
    /// Aggregate weekly category data into model
    func generateCategoryDataModels(from allExpenses: [DailyExpense]) -> [CategoryExpenseDataModel] {
        let today = Date()
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: today)!

        let weeklyExpenses = allExpenses.filter {
            $0.date >= sevenDaysAgo && $0.date <= today
        }

        var categoryTotals: [Category: Double] = [:]

        for expense in weeklyExpenses {
            let total = expense.item.reduce(0) { $0 + $1.price }
            categoryTotals[expense.category, default: 0] += total
        }

        let models = categoryTotals.map { (category, amount) in
            CategoryExpenseDataModel(
                icon: category.image,
                categoryName: category,
                amount: amount
            )
        }

        return models.sorted(by: { $0.amount > $1.amount })
    }
    
    @objc func detailExpenseTapped(_ sender: CategoryTapGestureRecognizer) {
        guard let indexPath = sender.indexPath else { return }
        print("Tapped")

        let selectedCategory = categoricalExpenses[indexPath.row].categoryName
        print(selectedCategory)
        print(type(of: selectedCategory))

        let detailVC = CategoricalExpenseViewController()

        detailVC.selectedCategory = selectedCategory
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(detailVC, animated: true)
    }


    
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoricalExpenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = categoricalExpenses[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryExpenseTableViewCell.identifier,
            for: indexPath) as? CategoryExpenseTableViewCell else {
            return UITableViewCell()
        }

        let recognizer = CategoryTapGestureRecognizer(target: self, action: #selector(detailExpenseTapped))
        recognizer.indexPath = indexPath
        cell.categoryCellView.isUserInteractionEnabled = true  // Ensure it's tappable
        cell.categoryCellView.addGestureRecognizer(recognizer)
        
        cell.selectionStyle = .none
        cell.configure(with: detail)
        return cell
    }

}

class CategoryTapGestureRecognizer: UITapGestureRecognizer {
    var indexPath: IndexPath?
}
