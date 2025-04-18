import UIKit

class CategoricalExpenseViewController: UIViewController {
    
    @IBOutlet weak var categoricalExpenseTableView: UITableView!
    var titleBarView :UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib  =  NavBarViewController(nibName: "NavBarViewController", bundle: nil)
        addChild(nib)
        self.titleBarView = nib.view
    }
    
    override func viewWillLayoutSubviews() {
        titleBarView.applyCardStyle()
        
        categoricalExpenseTableView.tableViewConstraints(for: self.view, from: titleBarView)
    }

}
