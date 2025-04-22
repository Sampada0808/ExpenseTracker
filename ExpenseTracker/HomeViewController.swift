import UIKit

class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var categoryTableView: UITableView!
    var titleBarView = UIView()
    
    // MARK: - Data Sources
//    var categoricalExpenses: [CategoryExpenseDataModel] = []
//    var dailyExpense: [DailyExpense] =  []
    
    var categoricalExpenses: [CategoryExpenseDataModel] = [
            CategoryExpenseDataModel(icon: Category.medicine.image, categoryName: .medicine, amount: 350),
            CategoryExpenseDataModel(icon: Category.doctor.image, categoryName: .doctor, amount: 800),
            CategoryExpenseDataModel(icon: Category.groceries.image, categoryName: .groceries, amount: 1200),
            CategoryExpenseDataModel(icon: Category.snacks.image, categoryName: .snacks, amount: 150),
            CategoryExpenseDataModel(icon: Category.fruits.image, categoryName: .fruits, amount: 300),
            CategoryExpenseDataModel(icon: Category.vegetables.image, categoryName: .vegetables, amount: 250),
            CategoryExpenseDataModel(icon: Category.online.image, categoryName: .online, amount: 600),
            CategoryExpenseDataModel(icon: Category.miscellaneous.image, categoryName: .miscellaneous, amount: 400)
        ]

        var dailyExpense: [DailyExpense] = [
            DailyExpense(
                date: Date(), // Today
                category: .medicine,
                item: [
                    ExpenseItem(item: "Paracetamol", qty: "2", unit: "Strips", price: 100),
                    ExpenseItem(item: "Bandage", qty: "1", unit: "Pack", price: 50),
                    ExpenseItem(item: "Cough Syrup", qty: "1", unit: "Bottle", price: 200)
                ]
            ),
            DailyExpense(
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                category: .medicine,
                item: [
                    ExpenseItem(item: "Migraine", qty: "1", unit: "Strips", price: 100),
                    ExpenseItem(item: "Bandage", qty: "1", unit: "Pack", price: 50),
                    ExpenseItem(item: "Cough Syrup", qty: "1", unit: "Bottle", price: 200)
                ]
            ),
            
            DailyExpense(
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                category: .medicine,
                item: [
                    ExpenseItem(item: "Migraine", qty: "1", unit: "Strips", price: 100),
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
            ),
            DailyExpense(
                date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
                category: .fruits,
                item: [
                    ExpenseItem(item: "Apples", qty: "1", unit: "Kg", price: 150),
                    ExpenseItem(item: "Bananas", qty: "1", unit: "Dozen", price: 100),
                    ExpenseItem(item: "Oranges", qty: "1", unit: "Kg", price: 50)
                ]
            ),
            DailyExpense(
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                category: .vegetables,
                item: [
                    ExpenseItem(item: "Tomatoes", qty: "1", unit: "Kg", price: 40),
                    ExpenseItem(item: "Onions", qty: "1", unit: "Kg", price: 30),
                    ExpenseItem(item: "Spinach", qty: "1", unit: "Bunch", price: 20),
                    ExpenseItem(item: "Cauliflower", qty: "1", unit: "Piece", price: 60),
                    ExpenseItem(item: "Potatoes", qty: "2", unit: "Kg", price: 100)
                ]
            ),
            DailyExpense(
                date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
                category: .online,
                item: [
                    ExpenseItem(item: "Phone Cover", qty: "1", unit: "Piece", price: 250),
                    ExpenseItem(item: "Notebook", qty: "2", unit: "Packs", price: 150),
                    ExpenseItem(item: "Stationery", qty: "1", unit: "Set", price: 200)
                ]
            ),
            DailyExpense(
                date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
                category: .miscellaneous,
                item: [
                    ExpenseItem(item: "Gift Wrap", qty: "2", unit: "Rolls", price: 100),
                    ExpenseItem(item: "Sticky Notes", qty: "3", unit: "Pads", price: 150),
                    ExpenseItem(item: "Batteries", qty: "2", unit: "Pairs", price: 150)
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
        
        let navBarVC = NavBarViewController(nibName: "NavBarViewController", bundle: nil)
        addChild(navBarVC)
        if(!categoricalExpenses.isEmpty) {
            navBarVC.tipMessage = "Select any of the categories to get daily expense breakdown"
        }
        view.addSubview(navBarVC.view)
        navBarVC.view.pinToTop(of: view)
        navBarVC.didMove(toParent: self)
        self.titleBarView = navBarVC.view


        
        // Observer for new expense added
        NotificationCenter.default.addObserver(self, selector: #selector(handleExpense), name: NSNotification.Name("com.Spendly.addExpense"), object: nil)

        // Setup views
        view.addSubview(currentWeekLabel)
        view.addSubview(totalAmountLabel)
        view.addSubview(totalExpenseAmountLabel)
        view.addSubview(addButton)
        view.addSubview(noExpenseLabel)
        view.addSubview(messageLabel)


        // Setup TableView
        categoryTableView.dataSource = self
        categoryTableView.estimatedRowHeight = 72
        categoryTableView.rowHeight = UITableView.automaticDimension
        categoryTableView.separatorStyle = .none

    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        titleBarView.applyCardStyle()
        titleBarView.pinToTop(of: self.view)
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Reload table data, update labels
        categoryTableView.reloadData()
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
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current // 👈 Automatically uses the device's locale

        if let formattedAmount = formatter.string(from: NSNumber(value: totalExpenseAmount)) {
            totalExpenseAmountLabel.text = formattedAmount
            totalExpenseAmountLabel.sizeToFit()
        }
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

        let selectedCategoryName = categoricalExpenses[indexPath.row].categoryName

        // Filter the daily expenses for the selected category
        let filteredExpenses = dailyExpense.filter {
            $0.category.rawValue == selectedCategoryName.rawValue
        }

        // Instantiate and pass data
        let detailVC = CategoricalExpenseViewController()
        detailVC.selectedCategory = selectedCategoryName
        detailVC.filteredDailyExpenses = filteredExpenses  // only filtered data sent

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
