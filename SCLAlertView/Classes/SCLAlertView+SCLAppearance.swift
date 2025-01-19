//
//  SCLAlertView+SCLAppearance.swift
//  SCLAlertView
//
//  Created by 김건우 on 1/16/25.
//

import UIKit

public extension SCLAlertView {
    
    
    struct SCLAppearance {
        let kDefaultShadowOpacity: CGFloat
        let kCircleTopPosition: CGFloat
        let kCircleBackgroundTopPosition: CGFloat
        let kCircleHeight: CGFloat
        let kCircleIconHeight: CGFloat
        let kTitleHeight: CGFloat
        let kTitleMinimumScaleFactor: CGFloat
        let kWindowWidth: CGFloat
        var kWindowHeight: CGFloat
        var kTextHeight: CGFloat
        let kTextFieldHeight: CGFloat
        let kTextViewdHeight: CGFloat
        let kButtonHeight: CGFloat
        let circleBackgroundColor: UIColor
        let contentViewColor: UIColor
        let contentViewBorderColor: UIColor
        let titleColor: UIColor
        let subTitleColor: UIColor
        
        let margin: Margin
        /// Margin for SCLAlertView.
        public struct Margin {
            // vertical
            
            /// The spacing between title's top and window's top.
            public var titleTop: CGFloat
            /// The spacing between textView/customView's bottom and first button's top
            public var textViewBottom: CGFloat
            /// The spacing between buttons.
            public var buttonSpacing: CGFloat
            /// The spacing between textField.
            public var textFieldSpacing: CGFloat
            /// The last button's bottom margin aginst alertView's bottom
            public var bottom: CGFloat
            
            // Horizontal
            /// The subview's horizontal margin.
            public var horizontal: CGFloat = 12
            
            public init(
                titleTop: CGFloat = 30,
                textViewBottom: CGFloat = 12,
                buttonSpacing: CGFloat = 10,
                textFieldSpacing: CGFloat = 15,
                bottom: CGFloat = 14,
                horizontal: CGFloat = 12
            ) {
                self.titleTop = titleTop
                self.textViewBottom = textViewBottom
                self.buttonSpacing = buttonSpacing
                self.textFieldSpacing = textFieldSpacing
                self.bottom = bottom
                self.horizontal = horizontal
            }
        }
        
        // Fonts
        let kTitleFont: UIFont
        let kTextFont: UIFont
        let kButtonFont: UIFont
        
        // UI Options
        var disableTapGesture: Bool
        var showCloseButton: Bool
        var showCircularIcon: Bool
        var shouldAutoDismiss: Bool // Set this false to 'Disable' Auto hideView when SCLButton is tapped
        var contentViewCornerRadius: CGFloat
        var fieldCornerRadius: CGFloat
        var buttonCornerRadius: CGFloat
        var dynamicAnimatorActive: Bool
        var buttonsLayout: SCLAlertButtonLayout
        var textViewAlignment: NSTextAlignment = .center
        
        // Actions
        var hideWhenBackgroundViewIsTapped: Bool
        
        // Activity indicator
        var activityIndicatorStyle: UIActivityIndicatorView.Style
        
        public init(kDefaultShadowOpacity: CGFloat = 0.7,
                    kCircleTopPosition: CGFloat = 0.0,
                    kCircleBackgroundTopPosition: CGFloat = 6.0,
                    kCircleHeight: CGFloat = 56.0,
                    kCircleIconHeight: CGFloat = 20.0,
                    kTitleHeight:CGFloat = 25.0,
                    kWindowWidth: CGFloat = 240.0,
                    kWindowHeight: CGFloat = 178.0,
                    kTextHeight: CGFloat = 90.0,
                    kTextFieldHeight: CGFloat = 30.0,
                    kTextViewdHeight: CGFloat = 80.0,
                    kButtonHeight: CGFloat = 35.0,
                    kTitleFont: UIFont = UIFont.systemFont(ofSize: 20),
                    kTitleMinimumScaleFactor: CGFloat = 1.0,
                    kTextFont: UIFont = UIFont.systemFont(ofSize: 14),
                    kButtonFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                    showCloseButton: Bool = true,
                    showCircularIcon: Bool = true,
                    shouldAutoDismiss: Bool = true,
                    contentViewCornerRadius: CGFloat = 5.0,
                    fieldCornerRadius: CGFloat = 3.0,
                    buttonCornerRadius: CGFloat = 3.0,
                    hideWhenBackgroundViewIsTapped: Bool = false,
                    circleBackgroundColor: UIColor? = nil,
                    contentViewColor: UIColor? = nil,
                    contentViewBorderColor: UIColor = UIColorFromRGB(0xCCCCCC),
                    titleColor: UIColor? = nil,
                    subTitleColor: UIColor? = nil,
                    margin: Margin = Margin(),
                    dynamicAnimatorActive: Bool = false,
                    disableTapGesture: Bool = false,
                    buttonsLayout: SCLAlertButtonLayout = .vertical,
                    activityIndicatorStyle: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.medium,
                    textViewAlignment: NSTextAlignment = .center) {
            
            self.kDefaultShadowOpacity = kDefaultShadowOpacity
            self.kCircleTopPosition = kCircleTopPosition
            self.kCircleBackgroundTopPosition = kCircleBackgroundTopPosition
            self.kCircleHeight = kCircleHeight
            self.kCircleIconHeight = kCircleIconHeight
            self.kTitleHeight = kTitleHeight
            self.kWindowWidth = kWindowWidth
            self.kWindowHeight = kWindowHeight
            self.kTextHeight = kTextHeight
            self.kTextFieldHeight = kTextFieldHeight
            self.kTextViewdHeight = kTextViewdHeight
            self.kButtonHeight = kButtonHeight
            self.circleBackgroundColor = circleBackgroundColor ?? .defaultBackgroundColor
            self.contentViewColor = contentViewColor ?? .defaultBackgroundColor
            self.contentViewBorderColor = contentViewBorderColor
            self.titleColor = titleColor ?? .defaultTitleColor
            self.subTitleColor = subTitleColor ?? .defaultSubTitleColor
            
            self.margin = margin
            
            self.kTitleFont = kTitleFont
            self.kTitleMinimumScaleFactor = kTitleMinimumScaleFactor
            self.kTextFont = kTextFont
            self.kButtonFont = kButtonFont
            
            self.disableTapGesture = disableTapGesture
            self.showCloseButton = showCloseButton
            self.showCircularIcon = showCircularIcon
            self.shouldAutoDismiss = shouldAutoDismiss
            self.contentViewCornerRadius = contentViewCornerRadius
            self.fieldCornerRadius = fieldCornerRadius
            self.buttonCornerRadius = buttonCornerRadius
            
            self.hideWhenBackgroundViewIsTapped = hideWhenBackgroundViewIsTapped
            self.dynamicAnimatorActive = dynamicAnimatorActive
            self.buttonsLayout = buttonsLayout
            
            self.activityIndicatorStyle = activityIndicatorStyle
            
            self.textViewAlignment = textViewAlignment
        }
        
        mutating func setkWindowHeight(_ kWindowHeight: CGFloat) {
            self.kWindowHeight = kWindowHeight
        }
        
        mutating func setkTextHeight(_ kTextHeight: CGFloat) {
            self.kTextHeight = kTextHeight
        }
    }
}


extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
    
    static var defaultBackgroundColor: UIColor = .systemBackground
    
    static var defaultTitleColor: UIColor = .label
    
    static var defaultSubTitleColor: UIColor {
        return UIColor(light: UIColorFromRGB(0x4D4D4D), dark: UIColorFromRGB(0xADADAD))
    }
    
    static var defaultButtonTitleColor: UIColor = .systemBackground
}
