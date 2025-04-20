import UIKit

class CategoricalExpenseViewController: UIViewController {

    var navBarView: UIView!
    var selectedCategory: Category?
    var dateLabel: UILabel = UILabel()
    var backButton: UIButton = UIButton(type: .system)

    var expenses: [ExpenseItem] = [
        ExpenseItem(item: "Mango", qty: "1", unit: "Kg", price: 100.50),
        ExpenseItem(item: "Cherry", qty: "500", unit: "gm", price: 100.50),
        ExpenseItem(item: "Strawberry", qty: "200", unit: "gm", price: 100.50),
        ExpenseItem(item: "Pineapple", qty: "100", unit: "gm", price: 100.50)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("✅ viewDidLoad")

        print("Selected Category: \(selectedCategory?.rawValue ?? "None")")

        // Custom navbar
        let navBarVc = NavBarViewController(nibName: "NavBarViewController", bundle: nil)
        addChild(navBarVc)
        navBarView = navBarVc.view
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBarView)

        // Add Back button and label
        addBackButton()
        addLabel()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("🔄 viewWillLayoutSubviews")

        navBarView.applyCardStyle()
        navBarView.pinToTop(of: view)
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
}
