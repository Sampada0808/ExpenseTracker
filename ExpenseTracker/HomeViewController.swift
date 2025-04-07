import UIKit

class HomeViewController: UIViewController {
    

    @IBOutlet weak var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.dataSource = self
        categoryTableView.estimatedRowHeight = 72
        categoryTableView.rowHeight = UITableView.automaticDimension
        categoryTableView.separatorStyle = .none
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

