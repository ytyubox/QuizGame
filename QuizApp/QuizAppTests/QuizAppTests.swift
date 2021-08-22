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

    func test_OptionSelected_shouldNot_notifiesDelegateWithEmptySelection() throws {
        var history: [[String]] = []
        let sut = makeSUT(options: ["A1", "A2"]) { selected in
            history.append(selected)
        }

        sut.select(at: 0)

        XCTAssertEqual(history, [["A1"]])

        sut.deselect(at: 0)
        sut.select(at: 1)

        XCTAssertEqual(history, [["A1"], ["A2"]])
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

extension QuestionViewController: TestableTableView {}
