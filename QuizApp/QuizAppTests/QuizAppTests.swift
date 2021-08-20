//
/*
 *		Created by 游宗諭 in 2021/8/20
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 12.0
 */

@testable import QuizApp
import XCTest

import UIKit

// MARK: - QuestionViewController

class QuestionViewController: UIViewController {
    var question: String = ""
    let headerLabel = UILabel()
    
    convenience init(question: String) {
        self.init()
        self.question = question
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = question
    }
    
}


// MARK: - QuestionViewControllerTests

class QuestionViewControllerTests: XCTestCase {
    func test_viewDidLoad_should_renderQuestionHeaderText() throws {
        let sut = makeSUT(question: "Q1")
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.headerLabel.text, "Q1")
    }
    
    // MARK: - Helper

    typealias SUT = QuestionViewController
    func makeSUT(
        question: String,
        file: StaticString = #filePath,
        line: UInt = #line) -> SUT
    {
        QuestionViewController(question: question)
    }
}
