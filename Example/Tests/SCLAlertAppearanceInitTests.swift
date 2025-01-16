//
//  SCLAlertAppearanceTests.swift
//  SCLAlertView_Tests
//
//  Created by 김건우 on 1/16/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import XCTest
@testable import SCLAlertView

final class SCLAlertAppearanceTests: XCTestCase {
    
    func testWhenInitAppearance_ShouldShaowOpacityBe0Point7() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kDefaultShadowOpacity, 0.7)
    }
    
    func testWhenInitAppearance_ShouldCircleTopPositionBe0() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kCircleTopPosition, 0)
    }
    
    func testWhenInitAppearance_ShouldCircleBackgroundTopPositionBe6() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kCircleBackgroundTopPosition, 6.0)
    }
    
    func testWhenInitAppearance_ShouldCircleHeightBe56() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kCircleHeight, 56.0)
    }
    
    func testWhenInitAppearance_ShouldCircleIconHeightBe20() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kCircleIconHeight, 20.0)
    }
    
    func testWhenInitAppearance_ShouldTitleHeightBe25() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kTitleHeight, 25.0)
    }
    
    func testWhenInitAppearance_ShoulWindowWidthBe240() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kWindowHeight, 178.0)
    }
    
    func testWhenInitAppearance_ShouldTextHeightBe90() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kTextHeight, 90.0)
    }
    
    func textWhenInitAppearance_ShouldTextFieldHeightBe30() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kTextFieldHeight, 30)
    }
    
    func testWhenInitAppearance_ShouldTextViewHeightBe80() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kTextViewdHeight, 80)
    }
    
    func testWhenInitAppearance_ShouldButtonHeightBe35() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kButtonHeight, 35)
    }
    
    func testWhenInitAppearance_ShouldTitleFontSizeBe20() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kTitleFont, .systemFont(ofSize: 20))
    }
    
    func testWhenInitAppearance_ShouldTitleMinimumScaleFactorBe1() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kTitleMinimumScaleFactor, 1.0)
    }
    
    func testWhenInitAppearance_ShouldTextFontSizeBe14() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kTextFont, .systemFont(ofSize: 14))
    }
    
    func testWhenInitAppearance_ShouldButtonFontBoldAndSizeBe14() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.kButtonFont, .boldSystemFont(ofSize: 14))
    }
    
    func testWhenInitAppearance_ShouldShowCloseButtonBeTrue() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertTrue(alert.appearance.showCloseButton)
    }
    
    func testWhenInitAppearance_ShouldShowCircularIconBeTrue() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertTrue(alert.appearance.showCircularIcon)
    }
    
    func testWhenInitAppearance_ShouldAutoDismissBeTrue() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertTrue(alert.appearance.shouldAutoDismiss)
    }
    
    func testWhenInitAppearance_ShouldContentViewCornerRadiusBe5() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.contentViewCornerRadius, 5.0)
    }

    func testWhenInitAppearance_ShouldFieldCornerRadiusBe3() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.fieldCornerRadius, 3.0)
    }

    func testWhenInitAppearance_ShouldButtonCornerRadiusBe3() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.buttonCornerRadius, 3.0)
    }

    func testWhenInitAppearance_ShouldHideWhenBackgroundViewIsTappedBeFalse() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertFalse(alert.appearance.hideWhenBackgroundViewIsTapped)
    }

    func testWhenInitAppearance_ShouldCircleBackgroundColorBeNil() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.circleBackgroundColor, .systemBackground)
    }

    func testWhenInitAppearance_ShouldContentViewColorBeNil() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.contentViewColor, .systemBackground)
    }

    func testWhenInitAppearance_ShouldContentViewBorderColorBeLightGray() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.contentViewBorderColor, UIColorFromRGB(0xCCCCCC))
    }

    func testWhenInitAppearance_ShouldTitleColorBeNil() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.titleColor, .label)
    }

    func testWhenInitAppearance_ShouldSubTitleColorBeNil() {
        // given
        let alert = SCLAlertView()
        
        let subTitleColor = alert.appearance.subTitleColor
        
        let lightModeTrait = UITraitCollection(userInterfaceStyle: .light)
        let lightSubtitleColor = subTitleColor.resolvedColor(with: lightModeTrait)
        
        let darkModeTrait = UITraitCollection(userInterfaceStyle: .dark)
        let darkSubtitleColor = subTitleColor.resolvedColor(with: darkModeTrait)
        
        // then
        XCTAssertEqual(lightSubtitleColor, UIColorFromRGB(0x4D4D4D))
        XCTAssertEqual(darkSubtitleColor, UIColorFromRGB(0xADADAD))
    }

    func testWhenInitAppearance_ShouldMarginBeDefaultValue() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.margin.titleTop, 30)
        XCTAssertEqual(alert.appearance.margin.textViewBottom, 12)
        XCTAssertEqual(alert.appearance.margin.buttonSpacing, 10)
        XCTAssertEqual(alert.appearance.margin.textFieldSpacing, 15)
        XCTAssertEqual(alert.appearance.margin.bottom, 14)
        XCTAssertEqual(alert.appearance.margin.horizontal, 12)
    }

    func testWhenInitAppearance_ShouldDynamicAnimatorActiveBeFalse() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertFalse(alert.appearance.dynamicAnimatorActive)
    }

    func testWhenInitAppearance_ShouldDisableTapGestureBeFalse() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertFalse(alert.appearance.disableTapGesture)
    }

    func testWhenInitAppearance_ShouldButtonsLayoutBeVertical() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.buttonsLayout, .vertical)
    }

    func testWhenInitAppearance_ShouldActivityIndicatorStyleBeMedium() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.activityIndicatorStyle, .medium)
    }

    func testWhenInitAppearance_ShouldTextViewAlignmentBeCenter() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.appearance.textViewAlignment, .center)
    }
}
