//
/*
 *		Created by 游宗諭 in 2021/8/22
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 12.0
 */

@testable import QuizApp
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
