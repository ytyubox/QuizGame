//
/*
 *		Created by 游宗諭 in 2021/8/22
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 12.0
 */

import UIKit

class ResultViewController: UIViewController {
    private var summary = ""
    convenience init(summary: String) {
        self.init()
        self.summary = summary
    }

    let headerLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = summary
    }
}

import XCTest

final class ResultViewControllerTests: XCTestCase {
    func test_viewDidLoad_should_renderSummary() throws {
        let sut = makeSUT(summary: "a summary")

        XCTAssertEqual(sut.headerLabel.text, "a summary")
    }

    // MARK: - Helper

    typealias SUT = ResultViewController
    func makeSUT(
        summary: String,
        file _: StaticString = #filePath,
        line _: UInt = #line
    ) -> SUT {
        let sut = ResultViewController(summary: summary)
        sut.loadViewIfNeeded()
        return sut
    }
}
