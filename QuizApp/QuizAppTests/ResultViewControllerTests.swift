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
    let question: String
    let answer: String
    let isCorrect: Bool
}

class CorrectAnswerCell: UITableViewCell {
    let questionLabel = UILabel()
    let answerLabel = UILabel()
}

class WrongAnswerCell: UITableViewCell {}

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
        tableView.register(CorrectAnswerCell.self, forCellReuseIdentifier: "CorrectCell")
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        answers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        if answer.isCorrect {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CorrectCell", for: indexPath) as! CorrectAnswerCell
            cell.questionLabel.text = answer.question
            cell.answerLabel.text = answer.answer
            return cell
        } else {
            return WrongAnswerCell()
        }
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

    func test_viewDidLoadWithCorrectAnswer_should_ConfigCorrectCell() throws {
        let answer = makeAnswer(question: "Q1", answer: "A1", isCorrect: true)
        let cell = try XCTUnwrap(makeSUT(answers: [answer]).cell(at: 0) as? CorrectAnswerCell)

        XCTAssertEqual(cell.questionLabel.text, "Q1")
        XCTAssertEqual(cell.answerLabel.text, "A1")
    }

    func test_viewDidLoadWithWrongAnswer_should_RenderWrongAnswerCell() throws {
        XCTAssertTrue(makeSUT(answers: [makeAnswer(isCorrect: false)])
            .cell(at: 0) is WrongAnswerCell)
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

    func makeAnswer(question: String = "", answer: String = "", isCorrect: Bool = true) -> PresentableAnswer {
        PresentableAnswer(question: question, answer: answer, isCorrect: isCorrect)
    }
}

// MARK: - ResultViewController + TestableTableView

extension ResultViewController: TestableTableView {}
