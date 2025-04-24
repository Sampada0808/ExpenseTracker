import UIKit


protocol NewExpenseModalDelegate : AnyObject {
    func closeModal()
}

class NewExpenseModalView: UIView {
    
    var dailyExpenseEntry : [DailyExpense] = []
    weak var delegate : NewExpenseModalDelegate?
    var expenseToEdit: ExpenseItem?

    
    
    //Labels outlets
    @IBOutlet weak private var AddExpenseLabel: UILabel!
    @IBOutlet weak private var itemLabel: UILabel!
    @IBOutlet weak private var qtyLabel: UILabel!
    @IBOutlet weak private var unitLabel: UILabel!
    @IBOutlet weak private var costLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var submitButton: UIButton!
    @IBOutlet weak private var categoryLabel: UILabel!
    
    
    //TextFields outlets
    @IBOutlet weak private var itemTextField: UITextField!
    @IBOutlet weak private var qtyTextField: UITextField!
    @IBOutlet weak private var costTextField: UITextField!
    @IBOutlet weak private var dateTextField: UITextField!
    @IBOutlet weak private var unitTextField: UITextField!
    
    
    //Category Picker view outlet
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    @IBOutlet var contentView: UIView!
    
    private let qtyPicker = UIPickerView()
    private let unitPicker = UIPickerView()
    private let datePicker = UIDatePicker()
    
    private let qtyOptions = Array(1...1000).map { "\($0)" }
    private let unitOptions = ["Kg", "g", "L", "ml", "pcs","pkt","n/a","strips","gallon"]
    
    
    var productName: String {
        get { return itemTextField.text ?? "" }
        set { itemTextField.text = newValue }
    }

    var quantity: String {
        get { return qtyTextField.text ?? "" }
        set { qtyTextField.text = newValue }
    }

    var cost: String {
        get { return costTextField.text ?? "" }
        set { costTextField.text = newValue }
    }

    var date: String {
        get { return dateTextField.text ?? "" }
        set { dateTextField.text = newValue }
    }

    var unit: String {
        get { return unitTextField.text ?? "" }
        set { unitTextField.text = newValue }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    
    func initSubviews(){
        //Intialising  the file owner
        let nib = UINib(nibName: "NewExpenseModal", bundle: nil)
        nib.instantiate(withOwner:self)
        
        
        contentView.frame = bounds
        addSubview(contentView)
        
        settingUpUiLayout()
        
        qtyPicker.delegate = self
        qtyPicker.dataSource = self
        unitPicker.delegate = self
        unitPicker.dataSource = self

        qtyTextField.inputView = qtyPicker
        unitTextField.inputView = unitPicker
        

        qtyTextField.inputAccessoryView = createToolbar()
        unitTextField.inputAccessoryView = createToolbar()
        dateTextField.inputAccessoryView = createToolbar()

        setupDatePicker()
        setupModalView()
        
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource =  self
        categoryPickerView.tintColor = UIColor.lightGreen
        categoryPickerView.selectRow(3, inComponent: 0, animated: false)
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        dateTextField.inputView = datePicker
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formatter.string(from: sender.date)
    }
    
    func setExpenseData(expense: ExpenseItem, category: Category, date: Date) {
            itemTextField.text = expense.item
            qtyTextField.text = expense.qty
            unitTextField.text = expense.unit
            costTextField.text = String(expense.price)
            
            // Set the date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateTextField.text = dateFormatter.string(from: date)
            
            // Set the category in the picker view
            let index = Category.allCases.firstIndex(of: category) ?? 0
            categoryPickerView.selectRow(index, inComponent: 0, animated: false)
        }

    
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }

    @objc func dismissKeyboard() {
        endEditing(true)
    }

    private func settingUpUiLayout(){
        //changing the corner radius of the textfields
        [itemTextField, qtyTextField, costTextField, dateTextField, unitTextField].forEach {
            $0?.layer.cornerRadius = CGFloat(10)
                $0?.clipsToBounds = true
            }
        
        submitButton.layer.cornerRadius = CGFloat(submitButton.frame.height / 2)
        
        
        //Setting fonts
        AddExpenseLabel.font = UIFont.style(.h2)
        [itemLabel, qtyLabel, costLabel, dateLabel, categoryLabel, unitLabel].forEach {
            $0?.font = UIFont.style(.h3)
        }
    }
    
    func setupModalView(){
        self.layer.cornerRadius = CGFloat(25)
        self.layer.masksToBounds = true
    }
    
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        guard let item = itemTextField.text,
              let qty = qtyTextField.text,
              let unit = unitTextField.text,
              let price = costTextField.text,
              let dateStr = dateTextField.text,
              let parsedDate = dateFormatter.date(from: dateStr),
              !item.isEmpty, !qty.isEmpty, !unit.isEmpty, !price.isEmpty, !dateStr.isEmpty else {
            return
        }

        let date = Calendar.current.startOfDay(for: parsedDate)
        let selectedRow = categoryPickerView.selectedRow(inComponent: 0)
        let category = Category.allCases[selectedRow]
        let calendar = Calendar.current

        if let expenseToEdit = expenseToEdit {
            // Find the existing expense to edit
            if let originalDayIndex = dailyExpenseEntry.firstIndex(where: {
                $0.item.contains(where: { $0.id == expenseToEdit.id })
            }) {
                var originalDailyExpense = dailyExpenseEntry[originalDayIndex]

                // Find the specific item to edit
                if let itemIndex = originalDailyExpense.item.firstIndex(where: { $0.id == expenseToEdit.id }) {
                    let newNormalizedDate = calendar.startOfDay(for: date)

                    if originalDailyExpense.category == category &&
                        calendar.isDate(originalDailyExpense.date, equalTo: newNormalizedDate, toGranularity: .day) {

                        // Update only the modified fields of the existing expense item
                        originalDailyExpense.item[itemIndex].item = item
                        originalDailyExpense.item[itemIndex].qty = qty
                        originalDailyExpense.item[itemIndex].unit = unit
                        originalDailyExpense.item[itemIndex].price = Double(price) ?? 0.0
                        
                        // Update the dailyExpenseEntry
                        dailyExpenseEntry[originalDayIndex] = originalDailyExpense
                        print("1108:\(originalDailyExpense)")

                        // Notify listeners that the expense was updated
                        NotificationCenter.default.post(name: NSNotification.Name("com.Spendly.updateExpense"), object: nil, userInfo: ["updatedExpense": originalDailyExpense.item[itemIndex]])
                    } else {
                        // 1. Remove item from the original DailyExpense
                        let removedItem = originalDailyExpense.item.remove(at: itemIndex)

                        // 2. If that day becomes empty, remove the day itself
                        if originalDailyExpense.item.isEmpty {
                            dailyExpenseEntry.remove(at: originalDayIndex)
                        } else {
                            dailyExpenseEntry[originalDayIndex] = originalDailyExpense
                        }

                        // 3. Notify that the item was removed
                        NotificationCenter.default.post(name: NSNotification.Name("com.Spendly.removeExpense"), object: nil, userInfo: ["removedExpense": removedItem])

                        // 4. Try to add it to the new category/date
//                        if let newDayIndex = dailyExpenseEntry.firstIndex(where: {
//                            $0.category == category &&
//                            calendar.isDate($0.date, equalTo: newNormalizedDate, toGranularity: .day)
//                        }) {
//                            dailyExpenseEntry[newDayIndex].item.append(removedItem)
//
//                            // Notify about the updated day
//                            let updated = dailyExpenseEntry[newDayIndex]
//                            NotificationCenter.default.post(name: NSNotification.Name("com.Spendly.updateExpense"), object: nil, userInfo: ["updatedExpense": updated])
//                        } else {
//                            let newDailyExpense = DailyExpense(id: UUID(), date: newNormalizedDate, category: category, item: [removedItem])
//                            dailyExpenseEntry.append(newDailyExpense)
//
//                            // Notify that a new day was added
//                            NotificationCenter.default.post(name: NSNotification.Name("com.Spendly.addExpense"), object: nil, userInfo: ["newExpense": newDailyExpense])
//                        }


                    }
                }
            }
        } else {
            // Handle adding a new expense if no existing expense to edit
            let expense = ExpenseItem(id: UUID(), item: item, qty: qty, unit: unit, price: Double(price)!)
            let normalizedDate = calendar.startOfDay(for: date)

            if let index = dailyExpenseEntry.firstIndex(where: {
                $0.category == category && calendar.isDate($0.date, equalTo: normalizedDate, toGranularity: .day)
            }) {
                dailyExpenseEntry[index].item.append(expense)

                // Preserve the ID and update the list
                let updatedExpense = DailyExpense(
                    id: dailyExpenseEntry[index].id,
                    date: normalizedDate,
                    category: category,
                    item: dailyExpenseEntry[index].item
                )
                dailyExpenseEntry[index] = updatedExpense

                let userInfo: [String: DailyExpense] = ["updatedExpense": updatedExpense]
                NotificationCenter.default.post(name: NSNotification.Name("com.Spendly.updateExpense"), object: nil, userInfo: userInfo)
            } else {
                let dailyExpense = DailyExpense(
                    id: UUID(),  // New unique ID for new expense
                    date: normalizedDate,
                    category: category,
                    item: [expense]
                )
                dailyExpenseEntry.append(dailyExpense)

                let userInfo: [String: DailyExpense] = ["newExpense": dailyExpense]
                NotificationCenter.default.post(name: NSNotification.Name("com.Spendly.addExpense"), object: nil, userInfo: userInfo)
            }
        }

        delegate?.closeModal()
    }



    func normalizedDate(_ date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        delegate?.closeModal()
        
    }
}


extension NewExpenseModalView : UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case qtyPicker:
            return qtyOptions.count
        case unitPicker:
            return unitOptions.count
        case categoryPickerView:
            return Category.allCases.count
        default:
            return 0
        }
    }
    
}

extension NewExpenseModalView :UIPickerViewDelegate{

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case qtyPicker:
            return qtyOptions[row]
        case unitPicker:
            return unitOptions[row]
        case categoryPickerView:
            return Category.allCases[row].rawValue
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case qtyPicker:
            qtyTextField.text = qtyOptions[row]
        case unitPicker:
            unitTextField.text = unitOptions[row]
        default:
            break
        }
    }

}



