import XCTest
@testable import SCLAlertView

final class SCLAlertViewInitTests: XCTestCase {
    
    func testWhenInitSCLAlertView_ShouldFrameBeUIScrreenMainBounds() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.view.bounds, UIScreen.main.bounds)
    }
    
    func testWhenInitSCLAlertView_ShouldResizingMaskBeFlexibleWidthAndFlexibleHeight() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.view.autoresizingMask, [.flexibleWidth, .flexibleHeight])
    }
    
    func testWhenInitSCLAlertView_ShouldBackgroundColorBeDarkGray() {
        // given
        let alert = SCLAlertView()
        
        // then
        let darkGray = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        XCTAssertEqual(alert.view.backgroundColor, darkGray)
    }
    
    func testWhenInitSCLAlertView_ShouldFirstSubviewBeUIView() {
        // given
        let alert = SCLAlertView()
        
        guard let subview = alert.view.subviews[safe: 0] else {
            XCTFail("There has no subview")
            return
        }
        
        // then
        XCTAssertTrue(subview.isKind(of: UIView.self))
    }
    
    func testWhenInitSCLAlertView_ShouldContentViewCorneradiusBe5() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.contentView.layer.cornerRadius, 5.0)
    }
    
    func testWhenInitSCLAlertView_ShouldContentViewMastToBoundsBeTrue() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertTrue(alert.contentView.layer.masksToBounds)
    }
    
    func testWhenInitSCLAlertView_ShouldContentViewBorderWidthBe0Point5() {
        // given
        let alert = SCLAlertView()
        
        // then
        XCTAssertEqual(alert.contentView.layer.borderWidth, 0.5)
    }
    
    func testWhenInitSCLAlertView_ShouldHaveUILabelAndUITextViewNotSCLButton() {
        // given
        let alert = SCLAlertView()
        
        guard let subview0 = alert.contentView.subviews[safe: 0],
              let subview1 = alert.contentView.subviews[safe: 1] else {
            XCTFail("There has no subviews")
            return
        }
        
        // then
        XCTAssertEqual(alert.contentView.subviews.count, 2)
        XCTAssertTrue(subview0.isKind(of: UILabel.self))
        XCTAssertTrue(subview1.isKind(of: UITextView.self))
    }
}


fileprivate extension Array where Element == UIView {
    
    subscript(safe index: Int) -> UIView? {
        guard (0..<self.count).contains(index) else {
            return nil
        }
        return self[index]
    }
}
