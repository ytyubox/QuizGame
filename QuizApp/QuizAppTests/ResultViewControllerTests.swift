//
/*
 *		Created by 游宗諭 in 2021/8/22
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 12.0
 */

import UIKit

// MARK: - PresentableAnswer

struct PresentableAnswer {
    let question: String
    let answer: String
    let wrongAnswer: String?
    var isCorrect: Bool { wrongAnswer == nil }
}

// MARK: - CorrectAnswerCell

class CorrectAnswerCell: UITableViewCell {
    let questionLabel = UILabel()
    let answerLabel = UILabel()
}

// MARK: - WrongAnswerCell

class WrongAnswerCell: UITableViewCell {
    let questionLabel = UILabel()
    let correctAnswerLabel = UILabel()
    let wrongAnswerLabel = UILabel()
}

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
        tableView.register(CorrectAnswerCell.self, forCellReuseIdentifier: "CorrectAnswerCell")
        tableView.register(WrongAnswerCell.self, forCellReuseIdentifier: "WrongAnswerCell")
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        answers.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        if answer.isCorrect {
            return correctCell(for: answer, indexPath: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WrongAnswerCell", for: indexPath) as! WrongAnswerCell
            cell.questionLabel.text = answer.question
            cell.correctAnswerLabel.text = answer.answer
            cell.wrongAnswerLabel.text = answer.wrongAnswer
            return cell
        }
    }

    private func correctCell(for answer: PresentableAnswer, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CorrectAnswerCell", for: indexPath) as! CorrectAnswerCell
        cell.questionLabel.text = answer.question
        cell.answerLabel.text = answer.answer
        return cell
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

    func test_viewDidLoadWithCorrectAnswer_should_ConfigCorrectAnswerCell() throws {
        let answer = makeAnswer(question: "Q1", answer: "A1")
        let cell = try XCTUnwrap(makeSUT(answers: [answer]).cell(at: 0) as? CorrectAnswerCell)

        XCTAssertEqual(cell.questionLabel.text, "Q1")
        XCTAssertEqual(cell.answerLabel.text, "A1")
    }

    func test_viewDidLoadWithWrongAnswer_should_ConfigWrongAnswerCell() throws {
        let answer = makeAnswer(question: "Q1", answer: "A1", wrongAnswer: "wrong")
        let cell = try XCTUnwrap(makeSUT(answers: [answer]).cell(at: 0) as? WrongAnswerCell)

        XCTAssertEqual(cell.questionLabel.text, "Q1")
        XCTAssertEqual(cell.correctAnswerLabel.text, "A1")
        XCTAssertEqual(cell.wrongAnswerLabel.text, "wrong")
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

    func makeAnswer(question: String = "", answer: String = "", wrongAnswer: String? = nil) -> PresentableAnswer {
        PresentableAnswer(question: question, answer: answer, wrongAnswer: wrongAnswer)
    }
}

// MARK: - ResultViewController + TestableTableView

extension ResultViewController: TestableTableView {}
