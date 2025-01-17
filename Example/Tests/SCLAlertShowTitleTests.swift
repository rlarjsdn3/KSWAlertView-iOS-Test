//
//  SCLAlertShowTitleTests.swift
//  SCLAlertView_Tests
//
//  Created by 김건우 on 1/17/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import XCTest
@testable import SCLAlertView

final class SCLAlertShowTitleTests: XCTestCase {
    
    func testWhenShowSCLAlertView_ShouldReturnSCLAlertResponsder() {
        // given
        let alert = SCLAlertView()
        alert.addButton("Ok", action: { })
        alert.addButton("Cancel", action: { })
        
        // when
        let responder = alert.showSuccess("Hello, SCLAlertView!")
        
        // then
        XCTAssertEqual(responder.alertView, alert)
    }
}
