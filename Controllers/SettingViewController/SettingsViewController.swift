import UIKit

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var appThemeLabel: UILabel!
    @IBOutlet weak var modalView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsLabel.font = UIFont.style(.h2)
        settingsLabel.textColor = UIColor(.mediumGreen)
        appThemeLabel.font = UIFont.style(.secondaryText)
        modalView.layer.cornerRadius = CGFloat(5)

    }
    
    @IBAction func dismissBtnTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func segmentedControlValueChange(_ sender: UISegmentedControl) {
        let window = UIApplication.shared.connectedScenes.flatMap {($0 as? UIWindowScene)?.windows ?? []}.first { $0.isKeyWindow }
        
        if sender.selectedSegmentIndex == 0{
            window?.overrideUserInterfaceStyle = .light
        }else if sender.selectedSegmentIndex == 1{
            window?.overrideUserInterfaceStyle = .dark
        }else{
            window?.overrideUserInterfaceStyle = .unspecified
        }
        
        
    }
}
