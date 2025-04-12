import UIKit

class NewExpenseModalViewController: UIViewController {
    
    init(){
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
    }
    required init?(coder: NSCoder) {
        fatalError("Init coder not yet implemented")
    }
    

}
