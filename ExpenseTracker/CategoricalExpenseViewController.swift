import UIKit

class CategoricalExpenseViewController: UIViewController {

    var navBarView: UIView!
    var selectedCategory: Category?
    var filteredDailyExpenses: [DailyExpense] = []
    var backButton: UIButton = UIButton(type: .system)
    var tableHeightConstraint: NSLayoutConstraint?
    var dateToDateExpenses : DailyExpense!
    var tableDataSources: [DailyExpenseTableDataSource] = []

    


    override func viewDidLoad() {
        super.viewDidLoad()
        print("Here")
        view.backgroundColor = .white

        // Custom navbar
        let navBarVc = NavBarViewController(nibName: "NavBarViewController", bundle: nil)
        addChild(navBarVc)
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

    func addTableView(for dailyExpense: DailyExpense, in containerView: UIView, below dateLabel: UILabel) {
        let newTableView = UITableView()
        newTableView.translatesAutoresizingMaskIntoConstraints = false
        newTableView.register(UINib(nibName: "CustomHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomHeaderTableViewCell")
        newTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        newTableView.backgroundColor = UIColor.lightGreen
        let dataSource = DailyExpenseTableDataSource(dailyExpense: dailyExpense)
        tableDataSources.append(dataSource)
        newTableView.dataSource = dataSource



        containerView.addSubview(newTableView)
        setupFooter(for: newTableView, with: dailyExpense)
        setupTableHeader(for: newTableView)

        NSLayoutConstraint.activate([
            newTableView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            newTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            newTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])

        let tableHeightConstraint = newTableView.heightAnchor.constraint(equalToConstant: 100)
        tableHeightConstraint.isActive = true

        newTableView.reloadData()

        DispatchQueue.main.async {
            tableHeightConstraint.constant = newTableView.contentSize.height
        }

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
                containerView.bottomAnchor.constraint(equalTo: lineView.bottomAnchor)
            ])

        }
    }

    
    func addMultipleTables(in contentView: UIView) {
        var previousContainer: UIView = contentView

        if filteredDailyExpenses.isEmpty {
            print("No filtered expenses found.")
            return
        }
        
        let sortedExpenses = filteredDailyExpenses.sorted { $0.date > $1.date }

        for (index, dailyExpense) in sortedExpenses.enumerated() {
            let spacing: CGFloat = (index == 0) ? 0 : 5
            let containerView = addContainerView(in: contentView, below: previousContainer, spacing: spacing)

            let dateLabel = addLabel(to: containerView, from: dailyExpense)
            addTableView(for: dailyExpense, in: containerView, below: dateLabel)

            previousContainer = containerView
        }

        // Anchor last container to bottom of contentView
        previousContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
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
        
        if let headerView = Bundle.main.loadNibNamed("CustomHeaderTableViewCell", owner: self, options: nil)?.first as? CustomHeaderTableViewCell {
            
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
        if let footerView = Bundle.main.loadNibNamed("CustomHeaderTableViewCell", owner: self, options: nil)?.first as? CustomHeaderTableViewCell {
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()
            footerView.setFooter(with: dailyExpense) // ← Pass as single-day array

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
    let dailyExpense: DailyExpense

    init(dailyExpense: DailyExpense) {
        self.dailyExpense = dailyExpense
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyExpense.item.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expense = dailyExpense.item[indexPath.row]
        let category = dailyExpense.category
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomHeaderTableViewCell", for: indexPath) as! CustomHeaderTableViewCell
        print("Expense : \(expense) category:\(category)")
        cell.configure(with: expense, category: category)
        return cell
    }
}



