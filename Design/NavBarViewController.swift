import UIKit

class NavBarViewController: UIViewController {
    
    
    @IBOutlet weak var settingsMenu: UIImageView!
    @IBOutlet weak var helpBgIcon: UIView!
    @IBOutlet weak var helpIconImageView: UIImageView!
    @IBOutlet weak var titleNavBar: UILabel!
    @IBOutlet weak var SpendlyAppLabel: UILabel!
    @IBOutlet var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        helpBgIcon.layer.cornerRadius = CGFloat(25)
        helpBgIcon.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        helpIconImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        titleNavBar.applyCardStyle()
        
        NSLayoutConstraint.activate([
            SpendlyAppLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            helpBgIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            helpBgIcon.widthAnchor.constraint(equalToConstant: 50),
            helpBgIcon.heightAnchor.constraint(equalToConstant: 50),
            settingsMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4)
        ]
            
        )

    }
    
    func config(){
        let nib  =  NavBarViewController(nibName: "NavBarViewController", bundle: nil)
        addChild(nib)
    }

}
