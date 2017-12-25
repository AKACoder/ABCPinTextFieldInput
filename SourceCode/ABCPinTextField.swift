//
//  ABCPinTextField.swift
//  ABCPinTextField_demo
//
//  Created by AKACoder on 2017/11/30.
//  Copyright © 2017年 personal. All rights reserved.
//

import Foundation
import Neon
import Async

class ABCPinInputDashView: UIView {}

open class ABCPinTextField: UIView {
    var PinInputs = [ABCPinTextFieldInput]()
    var Config: ABCPinTextFieldConfig!
    
    public weak var Delegate: ABCPinTextFieldDelegate? = nil
    public var IsEnable: Bool = true {
        didSet {
            IsEnable ? ActivateTheInput() : InactivateTheInput()
            IsEnable ? Delegate?.Enabled?() : Delegate?.Disabled?()
        }
    }
    
    public init(with config: ABCPinTextFieldConfig, frame: CGRect) {
        Config = config
        super.init(frame: frame)
        
        InitInputs()
        Layout()
        EnableTapActions()
    }
    
    public init(with config: ABCPinTextFieldConfig) {
        Config = config
        super.init(frame: CGRect.zero)
        
        InitInputs()
        EnableTapActions()
    }
    
    public var Text: String {
        get {
            var ret = ""
            for input in PinInputs {
                ret += input.text ?? ""
            }
            
            return ret
        }
    }
    
    @discardableResult
    public func Layout() -> Bool {
        if(self.frame.isEmpty) { return false }

        self.groupAndFill(group: Group.horizontal,
                          views: PinInputs,
                          padding: Config.InputPadding)
        
        for (idx, input) in PinInputs.enumerated() {
            switch Config.Mode {
            case .PlainTextWithDash(let dashColor, let dashWidth, let dashHeight):
                SetInputToPlainTextDashMode(input, dashColor, dashWidth, dashHeight)
                break
                
            case .PlainTextWithBottomBorder(let borderColor, let borderWidth, let borderHeight):
                SetInputToPlainWithBottomBorderMode(input, borderColor, borderWidth, borderHeight)
                break
                
            case .PasswordTextWithDash(let dashColor, let dashWidth, let dashHeight):
                SetInputToPasswordTextDashMode(input, dashColor, dashWidth, dashHeight)
                break
                
            case .PasswordTextWithBottomBorder(let borderColor, let borderWidth, let borderHeight):
                SetInputToPasswordTextWithBottomBorderMode(input, borderColor, borderWidth, borderHeight)
                break
                
            case .CustomMode(let customDraw):
                customDraw?(input, idx)
                break
            }
        }

        return true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Config = nil
    }
}

extension ABCPinTextField {
    @objc func BeenTapped() {
        if(IsEnable) {
            ActivateTheInput()
        }
    }
    
    func EnableTapActions() {
        self.isUserInteractionEnabled = true
        let gr = UITapGestureRecognizer(target: self, action: #selector(self.BeenTapped))
        self.addGestureRecognizer(gr)
    }
    
    func ActivateTheInput() {
        var activited = false
        for input in PinInputs {
            input.isEnabled = true
            if(input.isFirstResponder) {
                activited = true
            }
        }
        
        if(activited) {
            return
        }
        
        SetInputToFirstResponder(input: self.PinInputs.first!)
    }
    
    func InactivateTheInput() {
        for input in PinInputs {
            input.isEnabled = false
        }
    }
}

extension ABCPinTextField {
    func InitInputs() {
        for i in 0...Config.PinCount - 1 {
            PinInputs.append(CreatPinInput(i))
        }
    }
    
    func CreatPinInput(_ idx: Int) -> ABCPinTextFieldInput {
        let input = ABCPinTextFieldInput(with: Config.InputConfig, idx: idx, handler: self)
        
        input.TextChanged = { [weak self] (input) in
            self?.PinInputChanged(input: input)
        }
        
        input.BeforeBackward = { [weak self] (input) in
            self?.PinDelete(input: input)
        }
        
        input.WillStartEdit = { [weak self] (input) in
            return self?.PinInputWillStartEdit(input: input) ?? true
        }
        
        self.addSubview(input)
        return input
    }

    func DrawDashView(for input: ABCPinTextFieldInput, color: UIColor, width: CGFloat, height: CGFloat) {
        let view = ABCPinInputDashView()
        self.addSubview(view)
        self.sendSubview(toBack: view)
        view.align(Align.underCentered,
                   relativeTo: input,
                   padding: -(input.height + height) / 2,
                   width: width,
                   height: height)
        view.backgroundColor = color
        
        input.DashView = view
        input.HideCursor = true
        input.backgroundColor = UIColor.clear
    }
    
    func DrawBorderView(for input: ABCPinTextFieldInput, color: UIColor, width: CGFloat, height: CGFloat) {
        let view = UIView()
        self.addSubview(view)
        self.sendSubview(toBack: view)
        view.align(Align.underCentered,
                   relativeTo: input,
                   padding: -height,
                   width: width,
                   height: height)
        view.backgroundColor = color
        input.HideCursor = false
        input.backgroundColor = UIColor.clear
    }
    
    func SetInputToPlainTextDashMode(_ input: ABCPinTextFieldInput, _ dashColor: UIColor,
                                     _ dashWidth: CGFloat, _ dashHeight: CGFloat) {
        input.isSecureTextEntry = false
        DrawDashView(for: input, color: dashColor, width: dashWidth, height: dashHeight)
    }
    
    func SetInputToPlainWithBottomBorderMode(_ input: ABCPinTextFieldInput, _ borderColor: UIColor,
                                             _ borderWidth: CGFloat, _ borderHeight: CGFloat) {
        input.isSecureTextEntry = false
        DrawBorderView(for: input, color: borderColor, width: borderWidth, height: borderHeight)
    }
    
    func SetInputToPasswordTextDashMode(_ input: ABCPinTextFieldInput, _ dashColor: UIColor,
                                        _ dashWidth: CGFloat, _ dashHeight: CGFloat) {
        input.isSecureTextEntry = true
        DrawDashView(for: input, color: dashColor, width: dashWidth, height: dashHeight)
    }
    
    func SetInputToPasswordTextWithBottomBorderMode(_ input: ABCPinTextFieldInput, _ borderColor: UIColor,
                                                    _ borderWidth: CGFloat, _ borderHeight: CGFloat) {
        input.isSecureTextEntry = true
        DrawBorderView(for: input, color: borderColor, width: borderWidth, height: borderHeight)
    }
}

extension ABCPinTextField {
    func PinInputWillStartEdit(input: ABCPinTextFieldInput) -> Bool {
        var targetInput: ABCPinTextFieldInput? = nil
        var ret = true
        
        for vInput in PinInputs {
            if("" == vInput.text) {
                if(input.Idx != vInput.Idx) {
                    ret = false
                } else {
                    ret = true
                }
                targetInput = vInput
                break
            }
        }
        
        if(nil == targetInput) {
            targetInput = PinInputs.last!
        }
        
        if(input.Idx != targetInput!.Idx) {
            ret = false
        } else {
            ret = true
        }
        
        SetInputToFirstResponder(input: targetInput!)
        return ret
    }
    
    func PinInputChanged(input: ABCPinTextFieldInput) {
        let isInputEmpty = ("" == input.text)
        Async.main {
            input.DashView?.isHidden = !isInputEmpty
        }
        if(isInputEmpty) {
            return
        }
        
        let nextIdx = input.Idx + 1
        if(nextIdx >= PinInputs.count) {
            ResignFirstResponder(input: input)
            return
        }
        
        SetInputToFirstResponder(input: PinInputs[nextIdx])
    }
    
    func PinDelete(input: ABCPinTextFieldInput) {
        let isInputEmpty = ("" == input.text)
        if(!isInputEmpty) {
            return
        }

        let prevIdx = input.Idx - 1
        if(prevIdx < 0) {
            return
        }
        let prevInput = PinInputs[prevIdx];
        prevInput.text = ""
        prevInput.DashView?.isHidden = false
        
        SetInputToFirstResponder(input: prevInput)
    }
    
    func SetInputToFirstResponder(input: UITextField) {
        if(input.isSecureTextEntry) {
            Async.main(after: 0.001) {
                input.becomeFirstResponder()
            }
        } else {
            Async.main(after: 0.001) {
                input.becomeFirstResponder()
            }
        }
    }
    
    func ResignFirstResponder(input: UITextField) {
        if(!input.isFirstResponder) { return }
        Async.main(after: 0.001) {
            input.resignFirstResponder()
            self.CompleteForResign()
        }
    }
}

extension ABCPinTextField: ABCPinTextFieldInputHandler {
    func ResignFirstResponderManually() {
        CompleteForResign()
    }
    
    func CompleteForResign() {
        if(!IsEnable) { return }
        InputComplete() ?
            Delegate?.FinishedResign?() : Delegate?.UnfinishedResign?()
    }
    
    func InputComplete() -> Bool {
        var ret = true
        for input in PinInputs {
            if(false != input.text?.isEmpty) {
                ret = false
                break
            }
        }
        
        return ret
    }
}










