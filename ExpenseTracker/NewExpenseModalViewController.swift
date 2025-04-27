import UIKit

protocol NewExpenseModalViewControllerDelegate: AnyObject {
    func showNonEditableAlert()
}

class NewExpenseModalViewController: UIViewController, NewExpenseModalDelegate {
    var expenseToEdit: ExpenseItem?
    var dailyExpenseEntry: [DailyExpense] = []
    var category: Category?
    var date: Date? 
    
    func closeModal() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    
    lazy var modalView : NewExpenseModalView = {
        let modalWidth = view.frame.width - CGFloat(30)
        let modalHeight = CGFloat(667)
        let frame = CGRect(x: 15, y: view.center.y - (modalHeight / 2), width: modalWidth, height: modalHeight)
        let modalView = NewExpenseModalView(frame: frame)
        return modalView
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        modalView.delegate =  self
        modalView.editableDelegate = self
        view.addSubview(modalView)
        modalView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        modalView.dailyExpenseEntry = self.dailyExpenseEntry
        
        if let expense = expenseToEdit, let category = category, let date = date {
            modalView.expenseToEdit = expense // Pass expense to edit
            modalView.setExpenseData(expense: expense, category: category, date: date)
        }

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: [.curveEaseOut]){
            self.modalView.transform = CGAffineTransform.identity
        }
    }
    required init?(coder: NSCoder) {
        fatalError("Init coder not yet implemented")
    }
    

}

extension NewExpenseModalViewController: NewExpenseModalViewControllerDelegate {
    func showNonEditableAlert() {
        let alert = UIAlertController(title: "Action Not Allowed", message: "Category and Date cannot be edited.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

