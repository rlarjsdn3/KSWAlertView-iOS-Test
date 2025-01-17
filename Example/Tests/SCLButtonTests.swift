//
//  SCLButtonTests.swift
//  SCLAlertView_Tests
//
//  Created by 김건우 on 1/16/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import XCTest
@testable import SCLAlertView

final class SCLButtonTests: XCTestCase {
    
    func testWhenAddingSCLButton_ShouldAddProperly() {
        // given
        let alert = SCLAlertView()
        
        // when
        alert.addButton("Title") { }
        
        // then
        guard let button = alert.buttons[safe: 0] else {
            XCTFail("There has no button")
            return
        }
        XCTAssertTrue(button.isKind(of: SCLButton.self))
    }
}

fileprivate extension Array where Element: UIButton {
    
    subscript(safe index: Int) -> Element? {
        guard (0..<self.count).contains(index) else {
            return nil
        }
        return self[index]
    }
}
