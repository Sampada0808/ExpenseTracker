import UIKit

class CategoricalExpenseViewController: UIViewController {

    var navBarView: UIView!
    var selectedCategory: Category?
    var dateLabel: UILabel = UILabel()
    var backButton: UIButton = UIButton(type: .system)
    var dailyExpenseTable = UITableView()
    var tableHeightConstraint: NSLayoutConstraint?


    var expenses: [ExpenseItem] = [
        ExpenseItem(item: "Mango", qty: "1", unit: "Kg", price: 100.50),
        ExpenseItem(item: "Cherry", qty: "500", unit: "gm", price: 100.50),
        ExpenseItem(item: "Strawberry", qty: "200", unit: "gm", price: 100.50),
        ExpenseItem(item: "Pineapple", qty: "100", unit: "gm", price: 100.50)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Custom navbar
        let navBarVc = NavBarViewController(nibName: "NavBarViewController", bundle: nil)
        addChild(navBarVc)
        navBarView = navBarVc.view
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBarView)
        dailyExpenseTable.register(UINib(nibName: "CustomHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomHeaderTableViewCell")

        // Add Back button and label
        addBackButton()
        addLabel()
        addTableView()
        
        // Reload table after initial setup
            dailyExpenseTable.reloadData()

        DispatchQueue.main.async {
                self.tableHeightConstraint?.constant = self.dailyExpenseTable.contentSize.height
            }
        
       
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        navBarView.applyCardStyle()
        navBarView.pinToTop(of: view)
        setupTableHeader()
        setupFooter()
        
    }
    
    override func viewDidLayoutSubviews() {
        tableHeightConstraint?.constant = dailyExpenseTable.contentSize.height
            // Add dashed line only once
            if view.viewWithTag(999) == nil {
                let lineView = UIView()
                lineView.tag = 999
                lineView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(lineView)
                
                NSLayoutConstraint.activate([
                    lineView.topAnchor.constraint(equalTo: dailyExpenseTable.bottomAnchor, constant: 25),
                    lineView.leadingAnchor.constraint(equalTo: dailyExpenseTable.leadingAnchor),
                    lineView.trailingAnchor.constraint(equalTo: dailyExpenseTable.trailingAnchor),
                    lineView.heightAnchor.constraint(equalToConstant: 1)
                ])
                
                view.layoutIfNeeded() // Make sure the frame is set
                lineView.addHorizontalDashedLine()
            }
    }

    func addBackButton() {
        backButton.setTitle("<", for: .normal)
        backButton.titleLabel?.font = UIFont.style(.h2)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: 10)
        ])
    }

    func addLabel() {
        dateLabel.text = "12 April 2025"
        dateLabel.font = UIFont.style(.body)
        dateLabel.textColor = .gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 4),
                    dateLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func addTableView(){
        dailyExpenseTable.translatesAutoresizingMaskIntoConstraints = false
        dailyExpenseTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(dailyExpenseTable)
        
        NSLayoutConstraint.activate([
            dailyExpenseTable.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            dailyExpenseTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            dailyExpenseTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])

        // Add height constraint with temporary value
        tableHeightConstraint = dailyExpenseTable.heightAnchor.constraint(equalToConstant: 1)
        tableHeightConstraint?.isActive = true

        dailyExpenseTable.backgroundColor = UIColor.lightGreen
        
        dailyExpenseTable.dataSource =  self
    }
    

    func setupTableHeader() {
        
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
    
    
    func setupFooter(){
        if let footerView =
            Bundle.main.loadNibNamed("CustomHeaderTableViewCell", owner: self, options: nil)?.first as? CustomHeaderTableViewCell {
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()
            footerView.setFooter()
            
            let targetSize = CGSize(width: dailyExpenseTable.frame.width, height: UIView.layoutFittingCompressedSize.height)
            let height = footerView.systemLayoutSizeFitting(targetSize).height
            
            footerView.frame = CGRect(x: 0, y: 0, width: dailyExpenseTable.frame.width, height: height)
            
            dailyExpenseTable.tableFooterView = footerView
            
        }
    }





}

extension CategoricalExpenseViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return expenses.count
  }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomHeaderTableViewCell", for: indexPath) as! CustomHeaderTableViewCell

        let expense = expenses[indexPath.row]
        cell.configure(with: expense)  

        return cell
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

