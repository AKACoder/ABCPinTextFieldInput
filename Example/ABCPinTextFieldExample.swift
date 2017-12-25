//
//  ABCPinTextFieldExample.swift
//  ABCPinTextField_demo
//
//  Created by AKACoder on 2017/12/25.
//  Copyright © 2017年 personal. All rights reserved.
//

import Foundation
import Neon
//import ABCPinTextFieldInput

class ABCPinTextFieldExample {
    //get pin input with default configure
    var pinInputWithDash: ABCPinTextField! = nil
    
    //get pin input with some configure
    var pinInputWithBottomBorder: ABCPinTextField! = nil
    var passwordPinInputWithDash: ABCPinTextField! = nil
    var passwordPinInputWithBottomBorder: ABCPinTextField! = nil
    
    //custom draw pin input
    var customPinInput: ABCPinTextField! = nil
    
    init(view: UIView) {
        CreatePinInput()
        SetDelegate()
        LayoutAllInput(on: view, inputs:
            [
                pinInputWithDash,
                pinInputWithBottomBorder,
                passwordPinInputWithDash,
                passwordPinInputWithBottomBorder,
                customPinInput
            ]
        )
    }
}

extension ABCPinTextFieldExample {
    func LayoutAllInput(on view: UIView, inputs: [ABCPinTextField]) {
        let inputWidth = UIScreen.main.bounds.width - 20
        let inputHeight: CGFloat = 60
        let inputPadding: CGFloat = 20
        
        var prevInput: ABCPinTextField? = nil
        for (idx, pinInput) in inputs.enumerated() {
            view.addSubview(pinInput)
            if(0 == idx) {
                pinInput.anchorToEdge(Edge.top, padding: 90,
                                      width: inputWidth,
                                      height: inputHeight)
            } else {
                pinInput.align(Align.underCentered,
                               relativeTo: prevInput!,
                               padding: inputPadding,
                               width: inputWidth,
                               height: inputHeight)
            }
            
            pinInput.Layout()
            prevInput = pinInput
        }
    }
}

extension ABCPinTextFieldExample: ABCPinTextFieldDelegate {
    func Enabled() {
        print("Enabled")
    }
    
    func Disabled() {
        print("Disabled")
    }
    func FinishedResign() {
        print("FinishedResign")
    }
    func UnfinishedResign() {
        print("UnfinishedResign")
    }
}

extension ABCPinTextFieldExample {
    func SetDelegate() {
        pinInputWithDash.Delegate = self
        
        pinInputWithBottomBorder.Delegate = self
        passwordPinInputWithDash.Delegate = self
        passwordPinInputWithBottomBorder.Delegate = self
        
        customPinInput.Delegate = self
    }
}

extension ABCPinTextFieldExample {
    func CreatePinInput() {
        //get pin input with default configure
        pinInputWithDash = GetPinInputWithDash()
        
        //get pin input with some configure
        pinInputWithBottomBorder = GetPinInputWithBorder(pinCount: 4)
        passwordPinInputWithDash = GetPasswordPinInputWithDash(pinCount: 4)
        passwordPinInputWithBottomBorder = GetPasswordPinInputWithBorder(pinCount: 8)
        
        //custom draw pin input
        customPinInput = GetCustomPinInput()
    }
    
    func GetPinInputWithDash() -> ABCPinTextField {
        let config = ABCPinTextFieldConfig()
        return ABCPinTextField(with: config)
    }
    
    func GetPinInputWithBorder(pinCount: Int) -> ABCPinTextField {
        let config = ABCPinTextFieldConfig()
        config.Mode = ABCPinMode.PlainTextWithBottomBorder(borderColor: UIColor.blue,
                                                           borderWidth: 40, borderHeight: 2)
        
        config.PinCount = pinCount
        return ABCPinTextField(with: config)
    }
    
    func GetPasswordPinInputWithDash(pinCount: Int) -> ABCPinTextField {
        let config = ABCPinTextFieldConfig()
        config.Mode = ABCPinMode.PasswordTextWithDash(dashColor: UIColor.red,
                                                      dashWidth: 30,
                                                      dashHeight: 2)
        
        config.PinCount = pinCount
        return ABCPinTextField(with: config)
    }
    
    func GetPasswordPinInputWithBorder(pinCount: Int) -> ABCPinTextField {
        let config = ABCPinTextFieldConfig()
        config.Mode = ABCPinMode.PasswordTextWithBottomBorder(borderColor: UIColor.gray,
                                                              borderWidth: 30, borderHeight: 2)
        
        config.PinCount = pinCount
        return ABCPinTextField(with: config)
    }
    
    func GetCustomPinInput() -> ABCPinTextField {
        let config = ABCPinTextFieldConfig()
        config.Mode = ABCPinMode.CustomMode(customDraw: { (input, idx) in
            //set corner radius
            input.layer.masksToBounds = true
            input.layer.cornerRadius = 4
            //set background
            input.backgroundColor = UIColor.lightGray
        })
        
        return ABCPinTextField(with: config)
    }
}

