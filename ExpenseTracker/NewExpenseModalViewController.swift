import UIKit

class NewExpenseModalViewController: UIViewController {
    
    
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
        view.addSubview(modalView)
       
    }
    required init?(coder: NSCoder) {
        fatalError("Init coder not yet implemented")
    }
    

}
