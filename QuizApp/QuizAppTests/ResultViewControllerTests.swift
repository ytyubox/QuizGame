//
/*
 *		Created by 游宗諭 in 2021/8/22
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 12.0
 */

import UIKit

struct PresentableAnswer {
    let isCorrect: Bool
}

class CorrectAnswerCell: UITableViewCell {}

// MARK: - ResultViewController

class ResultViewController: UIViewController, UITableViewDataSource {
    private var summary = ""
    private var answers: [PresentableAnswer] = []
    convenience init(summary: String, answers: [PresentableAnswer]) {
        self.init()
        self.summary = summary
        self.answers = answers
    }

    let headerLabel = UILabel()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = summary
        tableView.dataSource = self
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        answers.count
    }

    func tableView(_: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        CorrectAnswerCell()
    }
}

import XCTest

// MARK: - ResultViewControllerTests

final class ResultViewControllerTests: XCTestCase {
    func test_viewDidLoad_should_renderSummary() throws {
        let sut = makeSUT(summary: "a summary")

        XCTAssertEqual(sut.headerLabel.text, "a summary")
    }

    func test_viewDidLoadWithAnswers_should_RenderAnswers() throws {
        XCTAssertEqual(makeSUT(answers: []).numberOfCell(), 0)
        XCTAssertEqual(makeSUT(answers: [makeAnswer()]).numberOfCell(), 1)
        XCTAssertEqual(makeSUT(answers: [makeAnswer(), makeAnswer()]).numberOfCell(),
                       2)
    }

    func test_viewDidLoadWithCorrectAnswer_should_RenderCorrectAnswerCell() throws {
        XCTAssertTrue(makeSUT(answers: [PresentableAnswer(isCorrect: true)])
            .cell(at: 0) is CorrectAnswerCell)
    }

    // MARK: - Helper

    typealias SUT = ResultViewController
    func makeSUT(
        summary: String = "",
        answers: [PresentableAnswer] = [],
        file _: StaticString = #filePath,
        line _: UInt = #line
    ) -> SUT {
        let sut = ResultViewController(summary: summary, answers: answers)
        sut.loadViewIfNeeded()
        return sut
    }

    func makeAnswer() -> PresentableAnswer {
        PresentableAnswer(isCorrect: true)
    }
}

// MARK: - ResultViewController + TestableTableView

extension ResultViewController: TestableTableView {}
