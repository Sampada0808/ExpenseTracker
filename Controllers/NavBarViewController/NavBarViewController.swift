import UIKit

protocol NavBarViewControllerDelegate: AnyObject {
    func didTapSettings()
}

class NavBarViewController: UIViewController {
    
    
    @IBOutlet weak var settingsMenu: UIImageView!
    @IBOutlet weak var helpBgIcon: UIView!
    @IBOutlet weak var helpIconImageView: UIImageView!
    @IBOutlet weak var SpendlyAppLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    weak var delegate: NavBarViewControllerDelegate?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showHelpTips))
        [helpIconImageView,helpBgIcon].forEach{
            $0?.isUserInteractionEnabled = true
            $0?.addGestureRecognizer(tapGesture)
        }
        settingsMenu.isUserInteractionEnabled = true
        let tapSettingsGesture = UITapGestureRecognizer(target: self, action: #selector(showSettingModal))
        settingsMenu.addGestureRecognizer(tapSettingsGesture)
        
        makeTappableAreaLarger(for: helpIconImageView)
        makeTappableAreaLarger(for: settingsMenu)
    }
    
    func makeTappableAreaLarger(for view: UIView) {
        let tapArea = UIView()
        tapArea.frame = view.frame.insetBy(dx: -20, dy: -20) // Increase the tappable area by 20 points on each side
        tapArea.isUserInteractionEnabled = true
        view.superview?.addSubview(tapArea)
        tapArea.addGestureRecognizer(UITapGestureRecognizer(target: self, action: view == settingsMenu ? #selector(showSettingModal) : #selector(showHelpTips)))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        helpBgIcon.layer.cornerRadius = CGFloat(25)
        helpBgIcon.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        helpIconImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        NSLayoutConstraint.activate([
            SpendlyAppLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            helpBgIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            helpBgIcon.widthAnchor.constraint(equalToConstant: 50),
            helpBgIcon.heightAnchor.constraint(equalToConstant: 50),
            settingsMenu.topAnchor.constraint(equalTo: view.topAnchor, constant: 60)
        ]
            
        )

    }
    
    var tipMessage: String = "Change the theme using hamburger icon right side of the question mark and Select any of the categories to get daily expense breakdown"

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
