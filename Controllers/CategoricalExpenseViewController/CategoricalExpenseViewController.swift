import UIKit



class CategoricalExpenseViewController: UIViewController, NavBarViewControllerDelegate {

    var navBarView: UIView!
    var selectedCategory: Category?
    var filteredDailyExpenses: [DailyExpense] = []
    var backButton: UIButton = UIButton(type: .system)
    var tableHeightConstraint: NSLayoutConstraint?
    var dateToDateExpenses : DailyExpense!
    var tableDataSources: [DailyExpenseTableDataSource] = []
    var tableDelegates: [DailyExpenseTableDelegate] = []
    var homeVC: HomeViewController?
    
    
    func didTapSettings() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let settingsVC = storyboard.instantiateViewController(withIdentifier: "Settings") as? SettingsViewController {
            settingsVC.modalPresentationStyle = .overCurrentContext
            self.present(settingsVC, animated: true, completion: nil)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground

        // Custom navbar
        let navBarVc = NavBarViewController(nibName: "NavBarViewController", bundle: nil)
        addChild(navBarVc)
        navBarVc.tipMessage = "Select any of the rows to edit the expense and swift left on of the rows to delete that expense"
        navBarVc.didMove(toParent: self)
        navBarVc.delegate =  self
        navBarView = navBarVc.view
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBarView)
        
        

        // Add Back button and label
        addBackButton()
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 5),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Content View inside Scroll View
           let contentView = UIView()
           contentView.translatesAutoresizingMaskIntoConstraints = false
           scrollView.addSubview(contentView)

           NSLayoutConstraint.activate([
               contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
               contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
               contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
               contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
               contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
           ])
        
        addMultipleTables(in: contentView)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRemovedExpense(_:)),
            name: NSNotification.Name("com.Spendly.removeExpense"),
            object: nil
        )
        

        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateExpenseNotification(_:)), name: NSNotification.Name("com.Spendly.updateExpense"), object: nil)
    }
    
    
    
    @objc func handleRemovedExpense(_ notification: Notification) {
        guard let removedExpense = notification.userInfo?["removedExpense"] as? ExpenseItem else { return }
        // 1. Remove the expense from filteredDailyExpenses
        for (dateIndex, dailyExpense) in filteredDailyExpenses.enumerated() {
            if let itemIndex = dailyExpense.item.firstIndex(where: { $0.id == removedExpense.id }) {
                filteredDailyExpenses[dateIndex].item.remove(at: itemIndex)
                print("Item removed from filteredDailyExpenses")
                break
            }
        }
        
        filteredDailyExpenses.removeAll { $0.item.isEmpty }
        
           if filteredDailyExpenses.isEmpty {
               navigationController?.popViewController(animated: true)
               NotificationCenter.default.post(
                   name: NSNotification.Name("deleteExpense"),
                   object: nil,
                   userInfo: [
                       "updatedExpenses": filteredDailyExpenses,
                       "categoryRawValue": selectedCategory?.rawValue ?? ""
                   ]
               )

               return // Exit early, no need to update tables
           }
        
        // 3. Update tableDataSources
        for (index, dataSource) in tableDataSources.enumerated() {
            var dailyExpense = dataSource.dailyExpense
            
            if let itemIndex = dailyExpense.item.firstIndex(where: { $0.id == removedExpense.id }) {
                dailyExpense.item.remove(at: itemIndex)
                tableDataSources[index].dailyExpense = dailyExpense
                
                if let tableView = self.view.viewWithTag(100 + index) as? UITableView {
                    tableView.dataSource = tableDataSources[index]
                    tableView.delegate = tableDelegates[index]
                    tableView.reloadData()
                    tableView.setContentOffset(.zero, animated: true)
                    tableView.layoutIfNeeded()
                    if let heightConstraint = tableView.constraints.first(where: { $0.firstAttribute == .height }) {
                        heightConstraint.constant = tableView.contentSize.height
                    } else {
                        // If there is no height constraint yet, you can add one
                        let heightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
                        heightConstraint.isActive = true
                    }
                    
                    setupFooter(for: tableView, with: dailyExpense)
                    updateDailyExpenseInHomeVC(updatedExpense: dailyExpense)
                }
                NotificationCenter.default.post(
                    name: NSNotification.Name("deleteExpense"),
                    object: nil,
                    userInfo: [
                        "updatedExpenses": filteredDailyExpenses,
                        "categoryRawValue": selectedCategory?.rawValue ?? ""
                    ]
                )
            }
        }
    }




    
    
    func updateDailyExpenseInHomeVC(updatedExpense: DailyExpense) {
            // Ensure homeVC is not nil, then update the expense data
            homeVC?.updateExpenseInDailyExpenses(updatedExpense: updatedExpense)
        }
    
    @objc func handleUpdateExpenseNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let updatedExpense = userInfo["updatedExpense"] as? ExpenseItem {
//            // Update filteredDailyExpenses directly (search and replace expense item)
            for (dayIndex, dailyExpense) in filteredDailyExpenses.enumerated() {
                if let itemIndex = dailyExpense.item.firstIndex(where: { $0.id == updatedExpense.id }) {
                    filteredDailyExpenses[dayIndex].item[itemIndex] = updatedExpense
                    break // Stop looping once found
                }
            }
            
            for (index, dataSource) in tableDataSources.enumerated() {
                var dailyExpense = dataSource.dailyExpense

                if let itemIndex = dailyExpense.item.firstIndex(where: { $0.id == updatedExpense.id }) {
                    // Update the specific ExpenseItem
                    dailyExpense.item[itemIndex] = updatedExpense
                    
                    // Update the data source
                    tableDataSources[index].dailyExpense = dailyExpense

                    // Reload the corresponding table view
                    if let tableView = self.view.viewWithTag(100 + index) as? UITableView {
                        tableView.dataSource = tableDataSources[index]
                        tableView.delegate = tableDelegates[index] // In case delegates are updated
                        tableView.reloadData()
                        tableView.setContentOffset(.zero, animated: true)
                        tableView.layoutIfNeeded()

                        setupFooter(for: tableView, with: dailyExpense)
                        updateDailyExpenseInHomeVC(updatedExpense: dailyExpense)
                    }
                }
            }
            
            self.view.setNeedsLayout()
            NotificationCenter.default.post(name: NSNotification.Name("DailyExpensesUpdated"), object: nil, userInfo: ["updatedExpenses": filteredDailyExpenses])
        }
    }






    
    





    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        navBarView.applyCardStyle()
        navBarView.pinToTop(of: view)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    
    func addContainerView(in contentView: UIView, below topAnchorView: UIView, spacing: CGFloat) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchorView == contentView ? contentView.topAnchor : topAnchorView.bottomAnchor, constant: spacing),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        return containerView
    }
    




    func addLabel(to containerView: UIView, from dailyExpense: DailyExpense) -> UILabel {
        let dateLabel = UILabel()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")

        if Calendar.current.isDateInToday(dailyExpense.date) {
            dateLabel.text = "Today"
        } else {
            dateLabel.text = formatter.string(from: dailyExpense.date)
        }

        dateLabel.font = UIFont.style(.body)
        dateLabel.textColor = .gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5)
        ])

        return dateLabel
    }

    func addTableView(for dailyExpense: DailyExpense, in containerView: UIView, below dateLabel: UILabel, dailyExpenseEntry: [DailyExpense]) {
        let newTableView = UITableView()
        newTableView.translatesAutoresizingMaskIntoConstraints = false
        newTableView.register(UINib(nibName: "dailyExpenseDataTableViewCell", bundle: nil), forCellReuseIdentifier: "dailyExpenseDataTableViewCell")
        newTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        newTableView.backgroundColor = UIColor.lightGreen
        
        let dataSource = DailyExpenseTableDataSource(dailyExpense: dailyExpense)
        newTableView.dataSource = dataSource
        let dataDelegate = DailyExpenseTableDelegate(dailyExpense: dailyExpense, dailyExpenseEntry: dailyExpenseEntry, viewController: self)
        newTableView.delegate = dataDelegate
        tableDelegates.append(dataDelegate) // <- This keeps it alive

        containerView.addSubview(newTableView)
        
        setupTableHeader(for: newTableView)

        // Set the constraints for the table view
        NSLayoutConstraint.activate([
            newTableView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            newTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            newTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])

        // Add height constraint initially
        let tableHeightConstraint = newTableView.heightAnchor.constraint(equalToConstant: 100)
        tableHeightConstraint.isActive = true

        // Reload the table view to get the content size
        newTableView.reloadData()

        // Ensure layout pass is complete before adjusting height constraint
        DispatchQueue.main.async {
            // Update the height based on content size
            tableHeightConstraint.constant = newTableView.contentSize.height
            containerView.layoutIfNeeded() // Make sure layout is up-to-date
        }

        // Add footer and dashed line below the table view
        setupFooter(for: newTableView, with: dailyExpense) // Use the current dailyExpense

        // Add dashed line below the table
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lineView)

        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: newTableView.bottomAnchor, constant: 25),
            lineView.leadingAnchor.constraint(equalTo: newTableView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: newTableView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])

        // Ensure layout pass is complete before drawing dashed line
        DispatchQueue.main.async {
            lineView.setNeedsLayout()
            lineView.layoutIfNeeded()
            lineView.addHorizontalDashedLine()

            NSLayoutConstraint.activate([
                containerView.bottomAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 25)
            ])
        }


        // Assign a tag to the table view for later reference
        newTableView.tag = 100 + tableDataSources.count

        // Append the data source to the list
        tableDataSources.append(dataSource)
        
        // Reload the table after all setup
        reloadTable(newTableView, with: dailyExpense)
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    func addMultipleTables(in contentView: UIView) {
        var previousContainer: UIView = contentView

        if filteredDailyExpenses.isEmpty {
            return
        }

        // Group expenses by date
        let groupedByDate = Dictionary(grouping: filteredDailyExpenses) { expense -> Date in
            return Calendar.current.startOfDay(for: expense.date)
        }

        // Sort dates descending
        let sortedDates = groupedByDate.keys.sorted(by: >)

        for (index, date) in sortedDates.enumerated() {
            let spacing: CGFloat = (index == 0) ? 0 : 0
            let containerView = addContainerView(in: contentView, below: previousContainer, spacing: spacing)

            // Combine all expenses for the same date into one DailyExpense
            let dailyEntries = groupedByDate[date] ?? []
            let combinedItems = dailyEntries.flatMap { $0.item }
            guard let first = dailyEntries.first else { continue }

            let mergedDailyExpense = DailyExpense(
                id: first.id, // Use the existing ID from any grouped item (or generate new if needed)
                date: date,
                category: first.category,
                item: combinedItems
            )


            let dateLabel = addLabel(to: containerView, from: mergedDailyExpense)

            addTableView(for: mergedDailyExpense, in: containerView, below: dateLabel, dailyExpenseEntry: dailyEntries)

            previousContainer = containerView
        }

        previousContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }

    func reloadTable(_ tableView: UITableView, with updatedExpense: DailyExpense) {
        tableView.reloadData()
        
        DispatchQueue.main.async {
            if let heightConstraint = tableView.constraints.first(where: { $0.firstAttribute == .height }) {
                heightConstraint.constant = tableView.contentSize.height
            }
            self.setupFooter(for: tableView, with: updatedExpense)
        }
    }


    func addBackButton() {
        backButton.setTitle("< Back", for: .normal)
        backButton.titleLabel?.font = UIFont.style(.h3)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: 10)
        ])
    }




    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    


    

    func setupTableHeader(for dailyExpenseTable: UITableView) {
        
        if let headerView = Bundle.main.loadNibNamed("CustomHeaderFooterTableViewCell", owner: self, options: nil)?.first as? CustomHeaderFooterTableViewCell {
            
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            
            let targetSize = CGSize(width: dailyExpenseTable.frame.width, height: UIView.layoutFittingCompressedSize.height)
            let height = headerView.systemLayoutSizeFitting(targetSize).height
            
            headerView.frame = CGRect(x: 0, y: 0, width: dailyExpenseTable.frame.width, height: height)
            headerView.setHeader()
            
            dailyExpenseTable.tableHeaderView = headerView
            dailyExpenseTable.layer.cornerRadius = CGFloat(10)
            dailyExpenseTable.layer.shadowColor = UIColor.black.cgColor
            dailyExpenseTable.layer.shadowRadius = 5
            dailyExpenseTable.layer.shadowOpacity = 0.2
            dailyExpenseTable.layer.shadowOffset = CGSize(width: 0, height: 5)
            dailyExpenseTable.layer.masksToBounds = false
        }
    }
    
    
    func setupFooter(for dailyExpenseTable: UITableView, with dailyExpense: DailyExpense){
        if let footerView = Bundle.main.loadNibNamed("CustomHeaderFooterTableViewCell", owner: self, options: nil)?.first as? CustomHeaderFooterTableViewCell {
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()
            footerView.setFooter(with: dailyExpense)

            let targetSize = CGSize(width: dailyExpenseTable.frame.width, height: UIView.layoutFittingCompressedSize.height)
            let height = footerView.systemLayoutSizeFitting(targetSize).height

            footerView.frame = CGRect(x: 0, y: 0, width: dailyExpenseTable.frame.width, height: height)

            dailyExpenseTable.tableFooterView = footerView
        }
    }


}


extension UIView {
    
    func addHorizontalDashedLine(color: UIColor = .gray, lineWidth: CGFloat = 1, dashPattern: [NSNumber] = [4, 2]) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = dashPattern
        shapeLayer.frame = bounds
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: bounds.midY), CGPoint(x: bounds.width, y: bounds.midY)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}

class DailyExpenseTableDataSource: NSObject, UITableViewDataSource {
    var dailyExpense: DailyExpense

    init(dailyExpense: DailyExpense) {
        self.dailyExpense = dailyExpense
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyExpense.item.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expense = dailyExpense.item[indexPath.row]
        let category = dailyExpense.category
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyExpenseDataTableViewCell", for: indexPath) as! dailyExpenseDataTableViewCell
        cell.configure(with: expense, category: category)
        cell.isUserInteractionEnabled = true
        cell.selectionStyle = .default
        return cell
    }
}


class DailyExpenseTableDelegate: NSObject, UITableViewDelegate {
    var dailyExpenseEntry: [DailyExpense]
    var dailyExpense: DailyExpense
    weak var viewController: UIViewController?

    init(dailyExpense: DailyExpense, dailyExpenseEntry: [DailyExpense], viewController: UIViewController) {
        self.dailyExpense = dailyExpense
        self.dailyExpenseEntry = dailyExpenseEntry
        self.viewController = viewController
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = dailyExpense.item[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Instantiate the NewExpenseModalViewController
        let modalVC = NewExpenseModalViewController()
        
        // Pass the selected item, category, and date to the modal
        modalVC.expenseToEdit = selectedItem
        modalVC.dailyExpenseEntry = dailyExpenseEntry
        modalVC.category = dailyExpense.category
        modalVC.date = dailyExpense.date
        
        // Present the modal view controller
        viewController?.present(modalVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
               guard let self = self else {
                   completionHandler(false)
                   return
               }
               
               let itemToDelete = self.dailyExpense.item[indexPath.row]
               
               // Post notification to remove the item
               NotificationCenter.default.post(
                   name: NSNotification.Name("com.Spendly.removeExpense"),
                   object: nil,
                   userInfo: ["removedExpense": itemToDelete, "TableView": tableView]
               )
               
               completionHandler(true)
           }
           
           let swipeConfig = UISwipeActionsConfiguration(actions: [delete])
           swipeConfig.performsFirstActionWithFullSwipe = false
           return swipeConfig
       }
    
}




