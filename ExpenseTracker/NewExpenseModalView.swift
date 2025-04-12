import UIKit

class NewExpenseModalView: UIView {
    

    //Labels outlets
    @IBOutlet weak var AddExpenseLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    //TextFields outlets
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var qtyTextFiels: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var unitTextFields: UITextField!
    
    
    //Category Picker view outlet
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    
    private func settingUpUiLayout(){
        //changing the corner radius of the textfields
        itemTextField.layer.cornerRadius = CGFloat(25)
        qtyTextFiels.layer.cornerRadius = CGFloat(25)
        costTextField.layer.cornerRadius = CGFloat(25)
        dateTextField.layer.cornerRadius = CGFloat(25)
        unitTextFields.layer.cornerRadius = CGFloat(25)
        
        submitButton.layer.cornerRadius = CGFloat(submitButton.frame.height / 2)
        
        
        //Setting fonts
        AddExpenseLabel.font =  UIFont.style(.h2)
        itemLabel.font = UIFont.style(.h3)
        qtyLabel.font = UIFont.style(.h3)
        costLabel.font = UIFont.style(.h3)
        dateLabel.font = UIFont.style(.h3)
        categoryLabel.font = UIFont.style(.h3)
        unitLabel.font = UIFont.style(.h3)
    }
    
    func setupModalView(){
        self.layer.cornerRadius = CGFloat(25)
        self.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingUpUiLayout()
        setupModalView()
        categoryPickerView.delegate = self
        categoryPickerView.dataSource =  self
        categoryPickerView.selectRow(3, inComponent: 0, animated: false)
    }
    
    
    
    
    
    @IBAction func submitBtnTapped(_ sender: Any) {
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        
    }
}


extension NewExpenseModalView : UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allCases.count
    }
    
}

extension NewExpenseModalView :UIPickerViewDelegate{
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let category =  Category.allCases[row].rawValue
//        return category
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel : UILabel? = view as? UILabel
        if pickerLabel == nil{
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.style(.secondaryText)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = Category.allCases[row].rawValue
        return pickerLabel!
    }
}
