//
//  SCLTextFieldTests.swift
//  SCLAlertView_Tests
//
//  Created by 김건우 on 1/16/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import XCTest
@testable import SCLAlertView

final class SCLTextFieldTests: XCTestCase {
    
    func testWhenAddingSCLTextField_ShouldAddProperly() {
        // given
        let alert = SCLAlertView()
        
        // when
        _ = alert.addTextField("Hello, SCLAlertView!")
        
        // then
        guard let textfield = alert.inputs[safe: 0] else {
            XCTFail("There has no textfields")
            return
        }
        XCTAssertTrue(textfield.isKind(of: UITextField.self))
    }
}

fileprivate extension Array where Element: UITextField {
    
    subscript(safe index: Int) -> Element? {
        guard (0..<self.count).contains(index) else {
            return nil
        }
        return self[index]
    }
}
