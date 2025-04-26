import UIKit

protocol NavBarViewControllerDelegate: AnyObject {
    func didTapSettings()
}

class NavBarViewController: UIViewController {
    
    
    @IBOutlet weak var settingsMenu: UIImageView!
    @IBOutlet weak var helpBgIcon: UIView!
    @IBOutlet weak var helpIconImageView: UIImageView!
    @IBOutlet weak var titleNavBar: UILabel!
    @IBOutlet weak var SpendlyAppLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    weak var delegate: NavBarViewControllerDelegate?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        helpIconImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showHelpTips))
            helpIconImageView.addGestureRecognizer(tapGesture)
        settingsMenu.isUserInteractionEnabled = true
            let tapSettingsGesture = UITapGestureRecognizer(target: self, action: #selector(showSettingModal))
        settingsMenu.addGestureRecognizer(tapSettingsGesture)
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
    
    var tipMessage: String = "Tap + button to add a new expense and change the theme using hamburger icon right side of the question mark"

    @objc func showHelpTips() {
        let alertVC = UIAlertController(title: "Tips", message: tipMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Got it!", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    @objc func showSettingModal() {
        delegate?.didTapSettings()
    }



    
    func config(){
        let nib  =  NavBarViewController(nibName: "NavBarViewController", bundle: nil)
        addChild(nib)
    }
    
    
}
