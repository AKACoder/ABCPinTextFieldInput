//
//  ABCPinTextFieldInput.swift
//  ABCPinTextField_demo
//
//  Created by AKACoder on 2017/11/30.
//  Copyright © 2017年 personal. All rights reserved.
//

import Foundation
import Neon

typealias ABCPinTextFieldInputWillStartEdit = (ABCPinTextFieldInput) -> Bool
typealias ABCPinTextFieldInputDidChanged = (ABCPinTextFieldInput) -> Void
typealias ABCPinTextFieldInputBeforeBackward = (ABCPinTextFieldInput) -> Void

protocol ABCPinTextFieldInputHandler: class {
    func ResignFirstResponderManually()
}

class ABCPinTextFieldInput: UITextField {
    fileprivate let ScreenScale = UIScreen.main.scale

    var Idx: Int = 0
    var WillStartEdit: ABCPinTextFieldInputWillStartEdit? = nil
    var TextChanged: ABCPinTextFieldInputDidChanged? = nil
    var BeforeBackward: ABCPinTextFieldInputBeforeBackward? = nil
    weak var DashView: ABCPinInputDashView? = nil
    weak var Handler: ABCPinTextFieldInputHandler? = nil
    var HideCursor: Bool = true {
        didSet {
            self.tintColor = HideCursor ? UIColor.clear : self.tintColor
        }
    }
    
    
    init(with config: ABCPinTextFieldInputConfig, idx: Int, handler: ABCPinTextFieldInputHandler) {
        super.init(frame: CGRect())
        self.delegate = self
        self.addTarget(self, action: #selector(self.TextDidChange), for: UIControlEvents.editingChanged)
        self.keyboardType = config.KeyboardType
        self.textAlignment = .center
        self.text = ""

        SetAccessoryBar(with: config)
        self.Handler = handler
        Idx = idx
    }
    
    deinit {
        WillStartEdit = nil
        TextChanged = nil
        BeforeBackward = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SetAccessoryBar(with config: ABCPinTextFieldInputConfig) {
        if(config.ShowAccessoryBar) {
            if(nil != config.CustomAccessoryView) {
                self.inputAccessoryView = config.CustomAccessoryView
                return
            }
            
            let view = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width, height: config.AccessoryBarHeight))
            view.backgroundColor = config.AccessoryBarColor
            self.inputAccessoryView = view

            DrawReturnButton(into: view, with: config)
        }
    }
    
    func DrawReturnButton(into view: UIView, with config: ABCPinTextFieldInputConfig) {
        
        let returnButton = UILabel()
        returnButton.text = config.AccessoryBarButtonText
        returnButton.textColor = config.AccessoryBarButtonTextColor
        

        returnButton.font = config.AccessoryBarButtonFont
        returnButton.text = config.AccessoryBarButtonText
        returnButton.textColor = config.AccessoryBarButtonTextColor
        returnButton.textAlignment = .center
        returnButton.sizeToFit()
        
        returnButton.isUserInteractionEnabled = true
        let gr = UITapGestureRecognizer(target: self, action: #selector(self.FinishButtonTouched))
        returnButton.addGestureRecognizer(gr)
        
        view.addSubview(returnButton)
        returnButton.anchorToEdge(Edge.right, padding: 40 / ScreenScale,
                                   width: returnButton.width * 2,
                                   height: view.height)
    }

    override func deleteBackward() {
        self.BeforeBackward?(self)
        super.deleteBackward()
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        let rect = super.caretRect(for: position)
        return CGRect(x: rect.origin.x, y: rect.origin.y, width: 1, height: rect.height)
    }

}


extension ABCPinTextFieldInput: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(!(textField is ABCPinTextFieldInput)) { return true }
        textField.resignFirstResponder()
        Handler?.ResignFirstResponderManually()
        return true;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let textField = textField as? ABCPinTextFieldInput else { return true }
        return textField.WillStartEdit?(textField) ?? true
    }
    
    @objc func TextDidChange(textField: UITextField) {
        guard let textField = textField as? ABCPinTextFieldInput else { return }

        let curTextCount = textField.text!.count
        let maxCharactersCount : Int = 1

        let selectedRange = textField.markedTextRange
        let lang = textField.textInputMode?.primaryLanguage
        let keboard = textField.keyboardType
        
        if("zh-Hans" == lang && UIKeyboardType.default == keboard) {
            if(nil == selectedRange) {
                if(0 != maxCharactersCount){
                    if(curTextCount > maxCharactersCount){
                        textField.text = (textField.text! as NSString).substring(to: maxCharactersCount)
                    }
                }
            }
        } else {
            if(0 != maxCharactersCount){
                if(curTextCount > maxCharactersCount){
                    textField.text = (textField.text! as NSString).substring(to: maxCharactersCount)
                }
            }
        }
        
        textField.TextChanged?(textField)
    }
    
    @objc func FinishButtonTouched(sender: UIGestureRecognizer) {
        if(self.isFirstResponder) {
            self.resignFirstResponder()
            Handler?.ResignFirstResponderManually()
        }
    }
}













