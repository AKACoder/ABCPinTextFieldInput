//
//  ABCPinTextFieldConfigAndProtocol.swift
//  ABCPinTextField_demo
//
//  Created by AKACoder on 2017/12/25.
//  Copyright © 2017年 personal. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol ABCPinTextFieldDelegate: class {
    @objc optional func Enabled()
    @objc optional func Disabled()
    @objc optional func FinishedResign()
    @objc optional func UnfinishedResign()
}

public typealias ABCPinTextFieldInputCustomDraw = (UITextField, Int) -> Void

public enum ABCPinMode {
    case PlainTextWithDash(dashColor: UIColor, dashWidth: CGFloat, dashHeight: CGFloat)
    case PasswordTextWithDash(dashColor: UIColor, dashWidth: CGFloat, dashHeight: CGFloat)
    case PlainTextWithBottomBorder(borderColor: UIColor, borderWidth: CGFloat, borderHeight: CGFloat)
    case PasswordTextWithBottomBorder(borderColor: UIColor, borderWidth: CGFloat, borderHeight: CGFloat)
    case CustomMode(customDraw: ABCPinTextFieldInputCustomDraw?)
}

public class ABCPinTextFieldConfig {
    public let InputConfig = ABCPinTextFieldInputConfig()
    public var PinCount: Int = 4
    public var InputPadding: CGFloat = 10
    public var Mode: ABCPinMode = .PlainTextWithDash(dashColor: UIColor.black, dashWidth: 40, dashHeight: 2)
    
    public init() {}
}

public class ABCPinTextFieldInputConfig {
    public var ShowAccessoryBar = true
    
    public var AccessoryBarColor = UIColor(red: 0xe5/255, green: 0xe5/255, blue: 0xe5/255, alpha: 1)
    public var AccessoryBarHeight:CGFloat = 120 / UIScreen.main.scale
    public var AccessoryBarButtonText = "完成"
    public var AccessoryBarButtonTextColor = UIColor.black
    public var AccessoryBarButtonFont = UIFont.systemFont(ofSize: 40 / UIScreen.main.scale)
    
    public var CustomAccessoryView: UIView? = nil
    
    public var KeyboardType: UIKeyboardType = .numberPad
    
    public init() {}
}


