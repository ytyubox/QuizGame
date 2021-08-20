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

class QuestionViewController: UIViewController, UITableViewDataSource {
    private var question: String = ""
    private var options: [String] = []
    let headerLabel = UILabel()
    let tableView = UITableView()

    convenience init(question: String, options: [String]) {
        self.init()
        self.question = question
        self.options =  options
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = question
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = options[indexPath.row]
        return cell
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

    func test_viewDidLoadWithOneOption_should_renderOneOption() throws {
        let sut = makeSUT(question: "Q1", options: ["A1"])
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_viewDidLoadWithOneOption_should_renderOneOptionText() throws {
        let sut = makeSUT(question: "Q1", options: ["A1"])
        sut.loadViewIfNeeded()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath)
        
        XCTAssertEqual(cell?.textLabel?.text, "A1")
    }

    // MARK: - Helper

    typealias SUT = QuestionViewController
    func makeSUT(
        question: String,
        options: [String],
        file _: StaticString = #filePath,
        line _: UInt = #line
    ) -> SUT {
        QuestionViewController(question: question, options: options)
    }
}
