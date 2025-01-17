//
//  SCLAlertStyle.swift
//  SCLAlertView
//
//  Created by 김건우 on 1/16/25.
//

import UIKit

// Pop up Styles
public enum SCLAlertViewStyle {
    case success, error, notice, warning, info, edit, wait, question
    
    public var defaultColor: UIColor {
        switch self {
        case .success:
            return UIColorFromRGB(0x22B573)
        case .error:
            return .init(light: UIColorFromRGB(0xC1272D), dark: .red)
        case .notice:
            return .init(light: UIColorFromRGB(0x727375), dark: UIColorFromRGB(0xC6C6C6))
        case .warning:
            return UIColorFromRGB(0xFFD110)
        case .info:
            return .init(light: UIColorFromRGB(0x2866BF), dark: UIColorFromRGB(0x6ABCe7))
        case .edit:
            return .init(light: UIColorFromRGB(0xA429FF), dark: UIColorFromRGB(0xD194FF))
        case .wait:
            return UIColorFromRGB(0xD62DA5)
        case .question:
            return .init(light: UIColorFromRGB(0x727375), dark: UIColorFromRGB(0xBABABA))
        }
    }
}

// Animation Styles
public enum SCLAnimationStyle {
    case noAnimation, topToBottom, bottomToTop, leftToRight, rightToLeft
}

// Action Types
public enum SCLActionType {
    case none, selector, closure
}

public enum SCLAlertButtonLayout {
    case horizontal, vertical
}
