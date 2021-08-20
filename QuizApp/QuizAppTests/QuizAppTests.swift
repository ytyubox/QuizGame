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

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var question: String = ""
    private var options: [String] = []
    private var selection: (([String]) -> Void)?
    let headerLabel = UILabel()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()

    static let cellReuseIdentifier = "Cell"
    convenience init(question: String, options: [String], selection: @escaping ([String]) -> Void) {
        self.init()
        self.question = question
        self.options = options
        self.selection = selection
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = question
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt _: IndexPath) {
        selectedOptions(in: tableView)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt _: IndexPath) {
        selectedOptions(in: tableView)
    }

    private func selectedOptions(in tableView: UITableView) {
        let selectedIndexPath = tableView.indexPathsForSelectedRows ?? []
        let selectedOptions = selectedIndexPath.map { options[$0.row] }
        selection?(selectedOptions)
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

    func test_MultipleOptionSelected_notifiesDelegate() throws {
        var history: [[String]] = []
        let sut = makeSUT(options: ["A1", "A2"]) { selected in
            history.append(selected)
        }

        sut.tableView.allowsMultipleSelection = true

        sut.select(at: 0)

        XCTAssertEqual(history, [["A1"]])

        sut.select(at: 1)

        XCTAssertEqual(history, [["A1"], ["A1", "A2"]])
    }

    func test_MultipleOptionDeselected_notifiesDelegate() throws {
        var history: [[String]] = []
        let sut = makeSUT(options: ["A1", "A2"]) { selected in
            history.append(selected)
        }

        sut.tableView.allowsMultipleSelection = true

        sut.select(at: 0)
        sut.select(at: 1)

        sut.deselect(at: 0)
        XCTAssertEqual(history, [["A1"], ["A1", "A2"], ["A2"]])
        sut.deselect(at: 1)
        XCTAssertEqual(history, [["A1"], ["A1", "A2"], ["A2"], []])
    }

    // MARK: - Helper

    typealias SUT = QuestionViewController
    func makeSUT(
        question: String = "",
        options: [String] = [],
        selection: @escaping ([String]) -> Void = { _ in },
        file _: StaticString = #filePath,
        line _: UInt = #line
    ) -> SUT {
        let sut = QuestionViewController(question: question, options: options, selection: selection)
        sut.loadViewIfNeeded()
        return sut
    }
}

extension QuestionViewController {
    var optionSection: Int { 0 }
    func cell(at row: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: row, section: optionSection)
        return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }

    func title(at row: Int) -> String? {
        cell(at: row)?.textLabel?.text
    }

    func numberOfCell() -> Int {
        tableView.numberOfRows(inSection: optionSection)
    }

    func select(at row: Int) {
        let indexPath = IndexPath(row: row, section: optionSection)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }

    func deselect(at row: Int) {
        let indexPath = IndexPath(row: row, section: optionSection)
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
}
