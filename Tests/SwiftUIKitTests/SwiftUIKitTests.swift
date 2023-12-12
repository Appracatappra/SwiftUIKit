import XCTest
@testable import SwiftUIKit

final class SwiftUIKitTests: XCTestCase {
    func testSwiftUIKit() throws {
        let control:WordArtView? = WordArtView(title: "Hello World")
        
        XCTAssert(control != nil)
    }
}
