//
//  PickerTableViewCell.swift
//  FEDD
//
//  Created by Dipansha  on 11/10/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell {

    @IBOutlet weak var valueField: UITextField! {
        didSet {
            valueField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        }
    }
    @IBOutlet weak var prompt: UILabel!
    
    var pickerView = UIPickerView()
    var value : Int = 0 {
        didSet {
            valueField.text = String(value)
        }
    }
    
    var sendInputBackDelegate: GetInputScore?
    var isBonusField = false {
        didSet {
            if isBonusField {
                promptText = "Bonus"
                valueField.inputView = nil
                valueField.inputAccessoryView = nil
                valueField.reloadInputViews()
                valueField.keyboardType = .decimalPad
            }
            else {
                setupPicker()
            }
        }
    }
    
    var maxValue = 1
    var promptText : String = "" {
        didSet {
            prompt.text = promptText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        valueField.text = ""
    }
    
    func donePicker() {
        valueField.resignFirstResponder()
    }
    
    func setupPicker() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        valueField.inputAccessoryView = toolBar
        pickerView.delegate = self
        valueField.inputView = pickerView
        pickerView.showsSelectionIndicator = true
    }
    
}

extension PickerTableViewCell : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        valueField.text = String(row)
        textFieldDidChange(valueField)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxValue+1;
    }
    
}

extension PickerTableViewCell {
    
    func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        if let intVal = Int(text) {
            sendInputBackDelegate?.getInputScore(prompt: promptText, score: intVal)
        }
    }
}
