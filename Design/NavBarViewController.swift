import UIKit

class NavBarViewController: UIViewController {
    
    
    @IBOutlet weak var settingsMenu: UIImageView!
    @IBOutlet weak var helpBgIcon: UIView!
    @IBOutlet weak var helpIconImageView: UIImageView!
    @IBOutlet weak var titleNavBar: UILabel!
    
    @IBOutlet var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        helpBgIcon.layer.cornerRadius = CGFloat(50)
        
        super.viewWillLayoutSubviews()
        titleNavBar.layer.cornerRadius = CGFloat(20)
        titleNavBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        titleNavBar.clipsToBounds = true
        titleNavBar.layer.shadowRadius =  CGFloat(5)
        titleNavBar.layer.shadowOpacity =  0.2
        titleNavBar.layer.shadowOffset =  CGSize(width: 0, height: 5)
        titleNavBar.layer.masksToBounds =  false
        
    }

}
