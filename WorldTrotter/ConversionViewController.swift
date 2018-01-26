//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Justin Weiss on 1/25/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    //Dismisses the keyboard when the background is clicked
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLable()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    func updateCelsiusLable() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    //Formats the number so only one decimal place is shown
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    } ()
    
    //Only allows one decimal to be enter in text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = NSCharacterSet(charactersIn:"0123456789").inverted
        let stringCharacters = string.components(separatedBy: allowedCharacters)
        
        let filtered = stringCharacters.joined(separator: "")
        
        if filtered == string {
            return true
        } else {
            if string == "." {
                let countdots = textField.text!.components(separatedBy:".").count - 1
                if countdots == 0 {
                    return true
                }else{
                    if countdots > 0 && string == "." {
                        return false
                    } else {
                        return true
                    }
                }
            }else{
                return false
            }
        }
        
        /*
        //print("Current text: \(textField.text)")
        //print("Replacement text: \(string)")
        
        //return true
        
        //print("Current text: \(textField.text)")
        //print("Replacement text: \(string)")
        
        //return true
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        //return string == numberFiltered
        
        //let allowedCharacters = CharacterSet.decimalDigits
        //let characterSet = CharacterSet(charactersIn: string)
        //return allowedCharacters.isSuperset(of: characterSet)
        
        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil, string != numberFiltered {
            return false
        } else {
            return true
        }
 */
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Updates Celsius label when app loads
        updateCelsiusLable()
    }
}
