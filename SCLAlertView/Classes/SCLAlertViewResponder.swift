//
//  SCLAlertViewResponder.swift
//  SCLAlertView
//
//  Created by 김건우 on 1/16/25.
//

import UIKit

// Allow alerts to be closed/renamed in a chainable manner
// Example: SCLAlertView().showSuccess(self, title: "Test", subTitle: "Value").close()
open class SCLAlertViewResponder {
    let alertView: SCLAlertView
    
    // Intialisation and Title/Subtitle/Close functions
    public init(alertView: SCLAlertView) {
        self.alertView = alertView
    }
    
    open func setTitle(_ title: String) {
        self.alertView.labelTitle.text = title
    }
    
    open func setSubtitle(_ subTitle: String?) {
        self.alertView.viewText.text = subTitle != nil ? subTitle : ""
    }
    
    open func close() {
        self.alertView.hideView()
    }
    
    open func setDismissBlock(_ dismissBlock: @escaping DismissBlock) {
        self.alertView.dismissBlock = dismissBlock
    }
}
