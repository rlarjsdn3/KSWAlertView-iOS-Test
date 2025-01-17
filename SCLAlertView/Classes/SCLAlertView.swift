//
//  SCLAlertView.swift
//  SCLAlertView-Swift-Clone
//
//  Created by 김건우 on 1/1/25.
//

import UIKit

let kCircleHeightBackground: CGFloat = 62.0
let uniqueTag: Int = Int(arc4random() % UInt32(Int32.max))
let uniqueAccessibilityIdentifier: String = "SCLAlertView"

public typealias DismissBlock = () -> Void

// The Main Class
open class SCLAlertView: UIViewController {
    
    var appearance: SCLAppearance!
    
    // UI Colour
    var viewColor = UIColor()
    
    // UI Options
    open var iconTintColor: UIColor?
    open var customSubview: UIView?
    
    // Members declaration
    var baseView = UIView()
    var labelTitle = UILabel()
    var viewText = UITextView()
    var contentView = UIView()
    var circleBG = UIView(frame: CGRect(x: 0, y: 0, width: kCircleHeightBackground, height: kCircleHeightBackground))
    var circleView = UIView()
    var circleIconView: UIView?
    var timeout: SCLTimeoutConfiguration?
    var showTimeoutTimer: Timer?
    var timeoutTimer: Timer?
    var dismissBlock: DismissBlock?
    var inputs = [UITextField]()
    fileprivate var input = [UITextView]()
    internal var buttons = [SCLButton]()
    fileprivate var selfReference: SCLAlertView?
    private var style: SCLAlertViewStyle!
    private var isUsingDefaultIconImage = true
    private var window: UIWindow!
    
    public init(appearance: SCLAppearance) {
        self.appearance = appearance
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    required public init() {
        appearance = SCLAppearance()
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        if appearance == nil {
            appearance = SCLAppearance()
        }
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    fileprivate func setup() {
        // Set up main view
        view.frame = UIScreen.main.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: isShowing() ? 0 : appearance.kDefaultShadowOpacity)
        view.addSubview(baseView)
        // Base View
        baseView.frame = view.frame
        baseView.addSubview(contentView)
        // Content View
        contentView.layer.cornerRadius = appearance.contentViewCornerRadius
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.addSubview(labelTitle)
        contentView.addSubview(viewText)
        // Circle View
        circleBG.backgroundColor = appearance.circleBackgroundColor
        circleBG.layer.cornerRadius = circleBG.frame.size.height / 2
        baseView.addSubview(circleBG)
        circleBG.addSubview(circleView)
        let x = (kCircleHeightBackground - appearance.kCircleHeight) / 2
        circleView.frame = CGRect(x: x, y: x + appearance.kCircleTopPosition, width: appearance.kCircleHeight, height: appearance.kCircleHeight)
        circleView.layer.cornerRadius = circleView.frame.size.height / 2
        // Title
        labelTitle.numberOfLines = 0
        labelTitle.textAlignment = .center
        labelTitle.font = appearance.kTitleFont
        if (appearance.kTitleMinimumScaleFactor < 1) {
            labelTitle.minimumScaleFactor = appearance.kTitleMinimumScaleFactor
            labelTitle.adjustsFontSizeToFitWidth = true
        }
        labelTitle.frame = CGRect(x: appearance.margin.horizontal, y: appearance.margin.titleTop, width: subViewsWidth, height: appearance.kWindowHeight)
        // View Text
        viewText.isEditable = false
        viewText.isSelectable = false
        viewText.textAlignment = appearance.textViewAlignment
        viewText.textContainerInset = UIEdgeInsets.zero
        viewText.textContainer.lineFragmentPadding = 0
        viewText.font = appearance.kTextFont
        // Colours
        contentView.backgroundColor = appearance.contentViewColor
        viewText.backgroundColor = appearance.contentViewColor
        labelTitle.textColor = appearance.titleColor
        viewText.textColor = appearance.subTitleColor
        contentView.layer.borderColor = appearance.contentViewBorderColor.cgColor
        // Gesture Recognizer for tapping outside the textinput
        if appearance.disableTapGesture == false {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SCLAlertView.tapped(_:)))
            tapGesture.numberOfTapsRequired = 1
            self.view.addGestureRecognizer(tapGesture)
        }
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard !keyboardHasBeenShown else {
            return
        }
        
        let sz = window.frame.size
        
        // Set background frame
        view.frame.size = sz
        
        let defaultTopOffset: CGFloat = 32
        
        // get actual height of title text
        var titleActualHeight: CGFloat = 0
        if let title = labelTitle.text {
            titleActualHeight = title.heightWithConstraintWidth(width: subViewsWidth, font: labelTitle.font) + 10
            // get the larger height for the title text
            titleActualHeight = (titleActualHeight > appearance.kTitleHeight ? titleActualHeight : appearance.kTitleHeight)
        }
        
        // computing the right size to use for the textView
        let maxHeight = sz.height - 100 // max overall height
        var consumedHeight = CGFloat(0)
        consumedHeight += (titleActualHeight > 0 ? appearance.margin.titleTop + titleActualHeight : defaultTopOffset)
        consumedHeight += appearance.margin.bottom
        
        let buttonMargin = appearance.margin.buttonSpacing
        let textFieldMargin = appearance.margin.textFieldSpacing
        if appearance.buttonsLayout == .vertical {
            consumedHeight += appearance.kButtonHeight * CGFloat(buttons.count)
            consumedHeight += buttonMargin * (CGFloat(buttons.count) - 1)
        } else {
            consumedHeight += appearance.kButtonHeight
        }
        consumedHeight += (appearance.kTextHeight + textFieldMargin) * CGFloat(inputs.count)
        consumedHeight += appearance.kTextViewdHeight * CGFloat(input.count)
        let maxViewTextHeight = maxHeight - consumedHeight
        let viewTextWidth = subViewsWidth
        var viewTextHeight = appearance.kTextHeight
        
        // Check if there is a custom subview and add it over the textview
        if let customSubview = customSubview {
            viewTextHeight = min(customSubview.frame.height, maxViewTextHeight)
            viewText.text = ""
            viewText.addSubview(customSubview)
        } else if viewText.text.isEmpty {
            viewTextHeight = 0
        } else {
            // computing the right size to use for the textView
            let suggestedViewTextSize = viewText.sizeThatFits(CGSize(width: viewTextWidth, height: CGFloat.greatestFiniteMagnitude))
            viewTextHeight = min(suggestedViewTextSize.height, maxViewTextHeight)
            
            // scroll management
            if (suggestedViewTextSize.height > maxViewTextHeight) {
                viewText.isScrollEnabled = true
            } else {
                viewText.isScrollEnabled = false
            }
        }
        
        var windowHeight = consumedHeight + viewTextHeight
        windowHeight += viewText.text.isEmpty ? 0 : appearance.margin.textViewBottom // only viewText.text is not empty shoud have margin.
        
        // Set frames
        var x = (sz.width - appearance.kWindowWidth) / 2
        var y = (sz.height - windowHeight - (appearance.kCircleHeight / 8)) / 2
        contentView.frame = CGRect(x: x, y: y, width: appearance.kWindowWidth, height: windowHeight)
        contentView.layer.cornerRadius = appearance.contentViewCornerRadius
        y -= kCircleHeightBackground * 0.6
        x = (sz.width - kCircleHeightBackground) / 2
        circleBG.frame = CGRect(x: x, y: y + appearance.kCircleTopPosition, width: kCircleHeightBackground, height: kCircleHeightBackground)
        
        // adjust Title frame based on circularIcon show/hide flag
        let titleOffset: CGFloat = 0
        labelTitle.frame = labelTitle.frame.offsetBy(dx: 0, dy: titleOffset)
        
        // Subtitle
        y = titleActualHeight > 0 ? appearance.margin.titleTop + titleActualHeight + titleOffset : defaultTopOffset
        viewText.frame = CGRect(x: appearance.margin.horizontal, y: y, width: viewTextWidth, height: viewTextHeight)
        // Text fields
        y += viewTextHeight
        y += viewText.text.isEmpty ? 0: appearance.margin.textViewBottom // only viewText.text is not empty should have margin.
        
        for txt in inputs {
            txt.frame = CGRect(x: appearance.margin.horizontal, y: y, width: subViewsWidth, height: appearance.kTextFieldHeight)
            txt.layer.cornerRadius = appearance.fieldCornerRadius
            y += appearance.kTextFieldHeight + textFieldMargin
        }
        for txt in input {
            txt.frame = CGRect(x: appearance.margin.horizontal, y: y, width: subViewsWidth, height: appearance.kTextViewdHeight - appearance.margin.textViewBottom)
            y += appearance.kTextViewdHeight
        }
        // Buttons
        var buttonX = appearance.margin.horizontal
        switch appearance.buttonsLayout {
        case .vertical:
            for btn in buttons {
                btn.frame = CGRect(x: buttonX, y: y, width: subViewsWidth, height: appearance.kButtonHeight)
                btn.layer.cornerRadius = appearance.buttonCornerRadius
                y += appearance.kButtonHeight + buttonMargin
            }
        case .horizontal:
            let numberOfButton = CGFloat(buttons.count)
            let buttonsSpace = numberOfButton >= 1 ? CGFloat(10) * (numberOfButton - 1) : 0
            let widthEachButton = (subViewsWidth - buttonsSpace) / numberOfButton
            for btn in buttons {
                btn.frame = CGRect(x: buttonX, y: y, width: widthEachButton, height: appearance.kButtonHeight)
                btn.layer.cornerRadius = appearance.buttonCornerRadius
                buttonX += widthEachButton
                buttonX += buttonsSpace // Check code later.
            }
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(SCLAlertView.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SCLAlertView.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil )
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if event?.touches(for: view)?.count > 0 {
            view.endEditing(true)
        }
    }
    
    open func addTextField(_ title: String? = nil) -> UITextField {
        // Update view height
        appearance.setkWindowHeight(appearance.kWindowHeight + appearance.kTextFieldHeight)
        // Add text field
        let txt = UITextField()
        txt.borderStyle = UITextField.BorderStyle.roundedRect
        txt.font = appearance.kTextFont
        txt.autocapitalizationType = UITextAutocapitalizationType.words
        txt.clearButtonMode = UITextField.ViewMode.whileEditing
        
        txt.layer.masksToBounds = true
        txt.layer.borderWidth = 1.0
        
        if title != nil {
            txt.placeholder = title!
        }
        
        contentView.addSubview(txt)
        inputs.append(txt)
        return txt
    }
    
    open func addTextView() -> UITextView {
        // Update view height
        appearance.setkWindowHeight(appearance.kWindowHeight + appearance.kTextViewdHeight)
        // Add text view
        let txt = UITextView()
        // No placegolder with UITextView but you can use KMPlaceholderTextView library
        txt.font = appearance.kTextFont
        
        txt.layer.masksToBounds = true
        txt.layer.borderWidth = 1.0
        contentView.addSubview(txt)
        input.append(txt)
        return txt
    }
    
    @discardableResult
    open func addButton(_ title: String, backgroundColor: UIColor? = nil, textColor: UIColor? = nil, showTimeout: SCLButton.ShowTimeoutConfiguration? = nil, action: @escaping () -> Void) -> SCLButton {
        let btn = addButton(title, backgroundColor: backgroundColor, textColor: textColor)
        btn.actionType = SCLActionType.closure
        btn.action = action
        btn.addTarget(self, action: #selector(SCLAlertView.buttonTapped(_:)), for: .touchUpInside)
        btn.addTarget(self, action: #selector(SCLAlertView.buttonTapDown(_:)), for: [.touchDown, .touchDragEnter])
        btn.addTarget(self, action: #selector(SCLAlertView.buttonRelease(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragOutside])
        return btn
    }
    
    @discardableResult
    open func addButton(_ title: String, backgroundColor: UIColor? = nil, textColor: UIColor? = nil, showTimeout: SCLButton.ShowTimeoutConfiguration? = nil, target: AnyObject, selector: Selector) -> SCLButton {
        let btn = addButton(title, backgroundColor: backgroundColor, textColor: textColor, showTimeout: showTimeout)
        btn.actionType = SCLActionType.selector
        btn.target = target
        btn.selector = selector
        btn.addTarget(self, action: #selector(SCLAlertView.buttonTapped(_:)), for: .touchUpInside)
        btn.addTarget(self, action: #selector(SCLAlertView.buttonTapDown(_:)), for: [.touchDown, .touchDragEnter])
        btn.addTarget(self, action: #selector(SCLAlertView.buttonRelease(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragOutside])
        return btn
    }
    
    @discardableResult
    fileprivate func addButton(_ title: String, backgroundColor: UIColor? = nil, textColor: UIColor? = nil, showTimeout: SCLButton.ShowTimeoutConfiguration? = nil) -> SCLButton {
        // Update view height
        appearance.setkWindowHeight(appearance.kWindowHeight + appearance.kButtonHeight)
        
        // Add button
        let btn = SCLButton()
        btn.layer.masksToBounds = true
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = appearance.kButtonFont
        btn.customBackgroundColor = backgroundColor
        btn.customTextColor = textColor
        btn.initalTitle = title
        btn.showTimeout = showTimeout
        contentView.addSubview(btn)
        buttons.append(btn)
        return btn
    }
    
    @objc func buttonTapped(_ btn: SCLButton) {
        if btn.actionType == SCLActionType.closure {
            btn.action()
        } else if btn.actionType == SCLActionType.selector {
            let ctrl = UIControl()
            ctrl.sendAction(btn.selector, to: btn.target, for: nil)
        } else {
            print("Unknown action type for button")
        }
        
        if (self.view.alpha != 0.0 && appearance.shouldAutoDismiss) { hideView() }
    }
    
    @objc func buttonTapDown(_ btn: SCLButton) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        let pressBrightnessFactor = 0.85
        btn.backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        brightness = brightness * CGFloat(pressBrightnessFactor)
        btn.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    @objc func buttonRelease(_ btn: SCLButton) {
        btn.backgroundColor = btn.customBackgroundColor ?? viewColor
    }
    
    var tmpContentViewFrameOrigin: CGPoint?
    var tmpCircleViewFrameOrigin: CGPoint?
    var keyboardHasBeenShown: Bool = false
    
    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardHasBeenShown = true
        
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let endKeyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.minY else { return }
        
        if tmpContentViewFrameOrigin == nil {
            tmpContentViewFrameOrigin = self.contentView.frame.origin
        }
        
        if tmpCircleViewFrameOrigin == nil {
            tmpCircleViewFrameOrigin = self.circleBG.frame.origin
        }
        
        var newContentViewFrameY = self.contentView.frame.maxY - endKeyBoardFrame
        if newContentViewFrameY < 0 {
            newContentViewFrameY = 0
        }
        
        let newBallViewFrameY = self.circleBG.frame.origin.y - newContentViewFrameY
        self.contentView.frame.origin.y -= newContentViewFrameY
        self.circleBG.frame.origin.y = newBallViewFrameY
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardHasBeenShown {  // This could happen on the simulator (keyboard will be hidden)
            if tmpContentViewFrameOrigin != nil {
                self.contentView.frame.origin.y = self.tmpContentViewFrameOrigin!.y
                self.tmpContentViewFrameOrigin = nil
            }
            if tmpCircleViewFrameOrigin != nil {
                self.circleBG.frame.origin.y = self.tmpCircleViewFrameOrigin!.y
                self.tmpCircleViewFrameOrigin = nil
            }
        }
    }
    
    // Dismiss keyboard when tapped outside textfield & close SCLAlertView when hideWhenBackgroundViewIsTapped
    @objc func tapped(_ gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
        if let tappedView = gestureRecognizer.view, tappedView.hitTest(gestureRecognizer.location(in: tappedView), with: nil) == baseView && appearance.hideWhenBackgroundViewIsTapped {
            hideView()
        }
    }
    
    // showCustom(view, title, subTitle, UIColor, UIImage)
    @discardableResult
    open func showCustom(_ title: String, subTitle: String? = nil, color: UIColor, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorTextButton: UIColor? = nil, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom, window: UIWindow? = nil) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .success, colorStyle: color, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle, window: window)
    }
    
    // showSuccess(view, title, subTitle)
    @discardableResult
    open func showSuccess(_ title: String, subTitle: String? = nil, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UIColor=SCLAlertViewStyle.success.defaultColor, colorTextButton: UIColor? = nil, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom, window: UIWindow? = nil) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .success, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle, window: window)
    }
    
    // showError(view, title, subTitle)
    @discardableResult
    open func showError(_ title: String, subTitle: String? = nil, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UIColor=SCLAlertViewStyle.error.defaultColor, colorTextButton: UIColor? = nil, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom, window: UIWindow? = nil) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .error, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle, window: window)
    }
    
    // showNotice(view, title, subTitle)
    @discardableResult
    open func showNotice(_ title: String, subTitle: String? = nil, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UIColor=SCLAlertViewStyle.notice.defaultColor, colorTextButton: UIColor? = nil, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom, window: UIWindow? = nil) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .notice, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle, window: window)
    }
    
    // showWarning(view, title, subTitle)
    @discardableResult
    open func showWarning(_ title: String, subTitle: String? = nil, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UIColor=SCLAlertViewStyle.warning.defaultColor, colorTextButton: UIColor = .black, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom, window: UIWindow? = nil) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .warning, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle, window: window)
    }
    
    // showInfo(view, title, subTitle)
    @discardableResult
    open func showInfo(_ title: String, subTitle: String? = nil, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UIColor=SCLAlertViewStyle.info.defaultColor, colorTextButton: UIColor? = nil, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom, window: UIWindow? = nil) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .info, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle, window: window)
    }
    
    // showWait(view, title, subTitle)
    @discardableResult
    open func showWait(_ title: String, subTitle: String? = nil, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UIColor?=SCLAlertViewStyle.wait.defaultColor, colorTextButton: UIColor? = nil, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom, window: UIWindow? = nil) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .wait, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle, window: window)
    }
    
    @discardableResult
    open func showEdit(_ title: String, subTitle: String? = nil, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UIColor=SCLAlertViewStyle.edit.defaultColor, colorTextButton: UIColor? = nil, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom, window: UIWindow? = nil) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, timeout: timeout, completeText:closeButtonTitle, style: .edit, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle, window: window)
    }
    
    // showTitle(view, title, subTitle, style)
    @discardableResult
    open func showTitle(_ title: String, subTitle: String? = nil, style: SCLAlertViewStyle, closeButtonTitle:String?=nil, timeout:SCLTimeoutConfiguration?=nil, colorStyle: UIColor = .black, colorTextButton: UIColor? = nil, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom, window: UIWindow? = nil) -> SCLAlertViewResponder {
        
        return showTitle(title, subTitle: subTitle, timeout:timeout, completeText:closeButtonTitle, style: style, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle, window: window)
    }
    
    // showTitle(view, title, subTitle, timeout, style)
    @discardableResult
    open func showTitle(_ title: String, subTitle: String? = nil, timeout: SCLTimeoutConfiguration?, completeText: String?, style: SCLAlertViewStyle, colorStyle: UIColor? = .black, colorTextButton: UIColor? = nil, circleIconImage: UIImage? = nil, animationStyle: SCLAnimationStyle = .topToBottom, window: UIWindow? = nil) -> SCLAlertViewResponder {
        selfReference = self
        view.alpha = 0
        view.tag = uniqueTag
        view.accessibilityIdentifier = uniqueAccessibilityIdentifier
        let rv = window ?? UIApplication.shared.windows.filter({$0.isKeyWindow}).first ??
        UIApplication.shared.windows.first!
        self.window = rv
        rv.addSubview(view)
        view.frame = rv.bounds
        baseView.frame = rv.bounds
        self.style = style
        
        // Alert colour
        viewColor = colorStyle ?? style.defaultColor
        
        // Title
        if !title.isEmpty {
            self.labelTitle.text = title
            let actualHeight = title.heightWithConstraintWidth(width: subViewsWidth, font: self.labelTitle.font)
            self.labelTitle.frame = CGRect(x:appearance.margin.horizontal, y:appearance.margin.titleTop, width: subViewsWidth, height:actualHeight)
        }
        
        // Subtitle
        if let subTitle = subTitle,
           !subTitle.isEmpty {
            viewText.text = subTitle
            // Adjust text view size, if necessary
            let str = subTitle as NSString
            let attr = [NSAttributedString.Key.font:viewText.font ?? UIFont()]
            let sz = CGSize(width: subViewsWidth, height:90)
            let r = str.boundingRect(with: sz, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attr, context:nil)
            let ht = ceil(r.size.height)
            if ht < appearance.kTextHeight {
                appearance.kWindowHeight -= (appearance.kTextHeight - ht)
                appearance.setkTextHeight(ht)
            }
        }
        
        // Done button
        if appearance.showCloseButton {
            
            // Retrieves the "done" word translated using Apple's UIKit dictionary
            let localizedDone = Bundle(for: UIApplication.self).localizedString(forKey: "Done", value: nil, table: nil)
            
            _ = addButton(completeText ?? localizedDone, target:self, selector:#selector(SCLAlertView.hideView))
        }
        
        //hidden/show circular view based on the ui option
        circleView.isHidden = !appearance.showCircularIcon
        circleBG.isHidden = !appearance.showCircularIcon
        
        // Alert view colour and images
        circleView.backgroundColor = viewColor
        
        // Spinner / icon
        if style == .wait {
            let indicator = UIActivityIndicatorView(style: appearance.activityIndicatorStyle)
            indicator.color = .defaultBackgroundColor
            indicator.startAnimating()
            circleIconView = indicator
        }
        else {
            isUsingDefaultIconImage = circleIconImage == nil
            let iconImage = circleIconImage ?? getIconImage()
            if let iconTintColor = iconTintColor {
                circleIconView = UIImageView(image: iconImage?.withRenderingMode(.alwaysTemplate))
                circleIconView?.tintColor = iconTintColor
            }
            else {
                circleIconView = UIImageView(image: iconImage)
            }
        }
        circleView.addSubview(circleIconView!)
        let x = (appearance.kCircleHeight - appearance.kCircleIconHeight) / 2
        circleIconView!.frame = CGRect( x: x, y: x, width: appearance.kCircleIconHeight, height: appearance.kCircleIconHeight)
        circleIconView?.layer.masksToBounds = true
        
        for txt in inputs {
            txt.layer.borderColor = viewColor.cgColor
        }
        
        for txt in input {
            txt.layer.borderColor = viewColor.cgColor
        }
        
        for btn in buttons {
            if let customBackgroundColor = btn.customBackgroundColor {
                // Custom BackgroundColor set
                btn.backgroundColor = customBackgroundColor
            } else {
                // Use default BackgroundColor derived from AlertStyle
                btn.backgroundColor = viewColor
            }
            
            if let customTextColor = btn.customTextColor {
                // Custom TextColor set
                btn.setTitleColor(customTextColor, for: .normal)
            } else {
                if let colorTextButton = colorTextButton {
                    btn.setTitleColor(colorTextButton, for: .normal)
                } else {
                    btn.setTitleColor(UIColor.defaultButtonTitleColor, for: .normal)
                }
            }
        }
        
        // Adding timeout
        if let timeout = timeout {
            self.timeout = timeout
            timeoutTimer?.invalidate()
            timeoutTimer = Timer.scheduledTimer(timeInterval: timeout.value, target: self, selector: #selector(SCLAlertView.hideViewTimeout), userInfo: nil, repeats: false)
            showTimeoutTimer?.invalidate()
            showTimeoutTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SCLAlertView.updateShowTimeout), userInfo: nil, repeats: true)
        }
        
        // Animate in the alert view
        self.showAnimation(animationStyle)
        
        // Chainable objects
        return SCLAlertViewResponder(alertView: self)
    }
    
    // Show animation in the alert view
    fileprivate func showAnimation(_ animationStyle: SCLAnimationStyle = .topToBottom, animationStartOffset: CGFloat = -400.0, boundingAnimationOffset: CGFloat = 15.0, animationDuration: TimeInterval = 0.2) {
        
        var animationStartOrigin = self.baseView.frame.origin
        var animationCenter: CGPoint = window.center
        
        switch animationStyle {
            
        case .noAnimation:
            self.view.alpha = 1.0
            return
            
        case .topToBottom:
            animationStartOrigin = CGPoint(x: animationStartOrigin.x, y: self.baseView.frame.origin.y + animationStartOffset)
            animationCenter = CGPoint(x: animationCenter.x, y: animationCenter.y + boundingAnimationOffset)
            
        case .bottomToTop:
            animationStartOrigin = CGPoint(x: animationStartOrigin.x, y: self.baseView.frame.origin.y - animationStartOffset)
            animationCenter = CGPoint(x: animationCenter.x, y: animationCenter.y - boundingAnimationOffset)
            
        case .leftToRight:
            animationStartOrigin = CGPoint(x: self.baseView.frame.origin.x + animationStartOffset, y: animationStartOrigin.y)
            animationCenter = CGPoint(x: animationCenter.x + boundingAnimationOffset, y: animationCenter.y)
            
        case .rightToLeft:
            animationStartOrigin = CGPoint(x: self.baseView.frame.origin.y - animationStartOffset, y: animationStartOrigin.y)
            animationCenter = CGPoint(x: animationCenter.x - boundingAnimationOffset, y: animationCenter.y)
        }
        
        self.baseView.frame.origin = animationStartOrigin
        
        // When people call SCLAlertView from viewDidLoad of their root UIViewController
        // on the app start we many end up with a non-key window and later our view will be covered
        // by the view controloler's view.
        // The best we can do is to bring our view to front later.
        let bringViewToFront = !window.isKeyWindow
        
        if self.appearance.dynamicAnimatorActive {
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.alpha = 1.0
            }, completion: { _ in
                if bringViewToFront {
                    self.window.bringSubviewToFront(self.view)
                }
            })
            self.animate(item: self.baseView, center: window.center)
        } else {
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.alpha = 1.0
                self.baseView.center = animationCenter
            }, completion: { finished in
                if bringViewToFront {
                    self.window.bringSubviewToFront(self.view)
                }
                UIView.animate(withDuration: animationDuration, animations: {
                    self.view.alpha = 1.0
                    self.baseView.center = self.window.center
                })
            })
        }
    }
    
    // DynamicAnimator function
    var animator: UIDynamicAnimator?
    var snapBehavior: UISnapBehavior?
    
    fileprivate func animate(item: UIView, center: CGPoint) {
        
        if let snapBehavior = self.snapBehavior {
            self.animator?.removeBehavior(snapBehavior)
        }
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        let tempSnapBehavior = UISnapBehavior(item: item, snapTo: center)
        self.animator?.addBehavior(tempSnapBehavior)
        self.snapBehavior = tempSnapBehavior
    }
    
    @objc func updateShowTimeout() {
        
        guard let timeout = self.timeout else {
            return
        }
        
        self.timeout?.value = timeout.value.advanced(by: -1)
        
        for btn in buttons {
            guard let showTimeout = btn.showTimeout else {
                continue
            }
            
            let timeoutStr: String = showTimeout.prefix + String(Int(timeout.value)) + showTimeout.suffix
            let txt = String(btn.initalTitle) + " " + timeoutStr
            btn.setTitle(txt, for: .normal)
        }
    }
    
    // Close SCLAlertView
    @objc open func hideView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        }, completion: { finished in
            
            // Stop timeoutTimer so alertView does not attempt to hide itself and fire it's dismiss a second time when close button is tapped
            self.timeoutTimer?.invalidate()
            
            if let dismissBlock = self.dismissBlock {
                // Call completion handler when the alert is dismissed
                dismissBlock()
            }
            
            // This is necessary for SCLAlertView to be de-initalized, preventing a strong reference cycle with the viewcontroller calling SCLAlertView.
            for button in self.buttons {
                button.action = nil
                button.target = nil
                button.selector = nil
            }
            
            self.view.removeFromSuperview()
            self.selfReference = nil
        })
    }
    
    @objc open func hideViewTimeout() {
        self.timeout?.action()
        self.hideView()
    }
    
    func checkCircleIconImage(_ circleIconImage: UIImage?, defaultImage: UIImage) -> UIImage {
        if let image = circleIconImage {
            return image
        } else {
            return defaultImage
        }
    }
    
    // Return true if a SCLAlertView is already being shown, false otherwise
    open func isShowing() -> Bool {
        if let subviews = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.subviews {
            for view in subviews {
                if view.tag == uniqueTag && view.accessibilityIdentifier == uniqueAccessibilityIdentifier {
                    return true
                }
            }
        }
        return false
    }
    
    private func getIconImage() -> UIImage? {
        switch style {
        case .wait, .none:
            return nil
        case .success:
            return SCLAlertViewStyleKit.imageOfCheckmark
        case .error:
            return SCLAlertViewStyleKit.imageOfCross
        case .notice:
            return SCLAlertViewStyleKit.imageOfNotice
        case .warning:
            return SCLAlertViewStyleKit.imageOfWarning
        case .info:
            return SCLAlertViewStyleKit.imageOfInfo
        case .edit:
            return SCLAlertViewStyleKit.imageOfEdit
        case .question:
            return SCLAlertViewStyleKit.imageOfQuestion
        }
    }
    
}


// Helper function to convert from RGB to UIColor
public func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension SCLAlertView {
    var subViewsWidth: CGFloat {
        return appearance.kWindowWidth - 2 * appearance.margin.horizontal
    }
}
