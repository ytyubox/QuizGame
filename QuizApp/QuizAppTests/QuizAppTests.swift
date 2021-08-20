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
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()

    static let cellReuseIdentifier = "Cell"
    convenience init(question: String, options: [String]) {
        self.init()
        self.question = question
        self.options = options
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = question
        tableView.dataSource = self
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
}

// MARK: - QuestionViewControllerTests

class QuestionViewControllerTests: XCTestCase {
    func test_viewDidLoad_should_renderQuestionHeaderText() throws {
        XCTAssertEqual(makeSUT(question: "Q1").headerLabel.text, "Q1")
    }

    func test_viewDidLoadWithOption_should_renderOption() throws {
        XCTAssertEqual(makeSUT(options: []).numberOfCell(), 0)
        XCTAssertEqual(makeSUT(options: ["A1"]).numberOfCell(), 1)
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).numberOfCell(), 2)
    }

    func test_viewDidLoad_should_renderOptionText() throws {
        XCTAssertEqual(makeSUT(options: ["A1"]).title(at: 0), "A1")
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).title(at: 0), "A1")
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).title(at: 1), "A2")
    }

    // MARK: - Helper

    typealias SUT = QuestionViewController
    func makeSUT(
        question: String = "",
        options: [String] = [],
        file _: StaticString = #filePath,
        line _: UInt = #line
    ) -> SUT {
        let sut = QuestionViewController(question: question, options: options)
        sut.loadViewIfNeeded()
        return sut
    }
}

extension QuestionViewController {
    var optionSection: Int { 0 }
    func cell(at index: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: index, section: optionSection)
        return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }

    func title(at index: Int) -> String? {
        cell(at: index)?.textLabel?.text
    }

    func numberOfCell() -> Int {
        tableView.numberOfRows(inSection: optionSection)
    }
}
