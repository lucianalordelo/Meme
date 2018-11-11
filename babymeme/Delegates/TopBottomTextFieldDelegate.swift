//
//  TopBottomTextFieldDelegate.swift
//  babymeme
//
//  Created by Luciana Lordelo Nascimento on 03/09/2018.
//  Copyright © 2018 Luciana Lordelo Nascimento. All rights reserved.
//

import Foundation
import UIKit

class TopBottomTextFieldDelegate : NSObject,UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       textField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //topTextField.resignFirstResponder()
        //bottomTextField.resignFirstResponder()
        return true
    }
    
}
