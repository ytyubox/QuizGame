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
    let tableView = UITableView()

    convenience init(question: String, options: [String]) {
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
        let sut = makeSUT(question: "Q1", options: [])
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.headerLabel.text, "Q1")
    }

    func test_viewDidLoadWithNoOptions_should_renderZeroOptions() throws {
        let sut = makeSUT(question: "Q1", options: [])
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }

    // MARK: - Helper

    typealias SUT = QuestionViewController
    func makeSUT(
        question: String,
        options: [String],
        file: StaticString = #filePath,
        line: UInt = #line) -> SUT
    {
        QuestionViewController(question: question, options: options)
    }
}
