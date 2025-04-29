import UIKit

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var themeControl: UISegmentedControl!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var appThemeLabel: UILabel!
    @IBOutlet weak var modalView: UIView!
    let window = UIApplication.shared.connectedScenes.flatMap {($0 as? UIWindowScene)?.windows ?? []}.first { $0.isKeyWindow }
    
    
    private func setupView(){
        guard let userPreference = UserDefaults.standard.object(forKey: "interfacePreference") as? Int else{
            if let window = window {
                switch window.overrideUserInterfaceStyle {
                case .light:
                    themeControl.selectedSegmentIndex = 0
                case .unspecified:
                    themeControl.selectedSegmentIndex = 1
                case .dark:
                    themeControl.selectedSegmentIndex = 2
                @unknown default:
                    themeControl.selectedSegmentIndex = 2
                }
            }
            return
        }
        themeControl.selectedSegmentIndex = userPreference

        if let window = window {
            switch userPreference {
            case 0:
                window.overrideUserInterfaceStyle = .light
            case 1:
                window.overrideUserInterfaceStyle = .dark
            case 2:
                window.overrideUserInterfaceStyle = .unspecified
            default:
                window.overrideUserInterfaceStyle = .unspecified
            }
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsLabel.font = UIFont.style(.h2)
        settingsLabel.textColor = UIColor(.mediumGreen)
        appThemeLabel.font = UIFont.style(.secondaryText)
        modalView.layer.cornerRadius = CGFloat(5)
        
        setupView()

    }
    
    @IBAction func dismissBtnTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func segmentedControlValueChange(_ sender: UISegmentedControl) {
        
        
        if sender.selectedSegmentIndex == 0{
            window?.overrideUserInterfaceStyle = .light
            UserDefaults.standard.set(0, forKey: "interfacePreference")
        }else if sender.selectedSegmentIndex == 1{
            window?.overrideUserInterfaceStyle = .dark
            UserDefaults.standard.set(1, forKey: "interfacePreference")
        }else{
            window?.overrideUserInterfaceStyle = .unspecified
            UserDefaults.standard.set(2, forKey: "interfacePreference")
        }
        
        
    }
}
