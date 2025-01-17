//
//  SCLAlertView+TimeoutConfiguration.swift
//  SCLAlertView
//
//  Created by 김건우 on 1/16/25.
//

import UIKit

public extension SCLAlertView {
    
    struct SCLTimeoutConfiguration {
        
        public typealias ActionType = () -> Void
        
        var value: TimeInterval
        let action: ActionType
        
        mutating func increaseValue(by: Double) {
            self.value = value + by
        }
        
        public init(timeoutValue: TimeInterval, timeoutAction: @escaping ActionType) {
            self.value = timeoutValue
            self.action = timeoutAction
        }
    }
}
