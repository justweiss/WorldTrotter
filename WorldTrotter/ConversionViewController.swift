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
    
    //Convertes fahrenheit to celsius and changes textfield
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
    
    //Convertes Fehrenheit to celsius
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    //Updates Celsius label so there is numbers or ??? in the textbox
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
    
    //Only allows one decimal to be enter in text field and only allows number digits to be entered.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = NSCharacterSet(charactersIn:"0123456789").inverted
        let stringCharacters = string.components(separatedBy: allowedCharacters)
        let filtered = stringCharacters.joined(separator: "")
        
        //Checks if the string is digits and only one decimal
        if filtered == string {
            return true
        } else {
            //If decimal is found
            if string == "." {
                //Counts how many decimals found
                let countDecimal = textField.text!.components(separatedBy:".").count - 1
                if countDecimal == 0 {
                    return true
                }else{
                    //If more then 2 found returns false
                    if countDecimal > 0 && string == "." {
                        return false
                    } else {
                        return true
                    }
                }
            }else{
                return false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let date = NSDate()
        let hours = Calendar.current.component(.hour, from: date as Date)
        
        let light = UIColor(red:0.96, green:0.96, blue:0.95, alpha:1.0)
        let dark = UIColor(red:0.50, green:0.50, blue:0.50, alpha:1.0)
        print("\(hours) is the hour")
        switch hours {
        case 0...6, 18...23:
            view.backgroundColor = dark
        default:
            view.backgroundColor = light
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
        
        //Updates Celsius label when app loads
        updateCelsiusLable()
    }
}
