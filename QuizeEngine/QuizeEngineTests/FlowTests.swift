import XCTest

// MARK: - Flow

class Flow {
    let router: Router
    let questions: [Question]
    private var result: [Question: Answer] = [:]

    init(questions: [Question], router: Router) {
        self.router = router
        self.questions = questions
    }

    func start() {
        guard let firstQuestion = questions.first else {
            router.routeTo(result: [:])
            return
        }
        router.routeTo(question: firstQuestion) {
            [unowned self] answer in
            routeNext(firstQuestion, answer)
        }
    }

    private func routeNext(_ question: Question, _ answer: Answer) {
        guard let currentQuestionIndex = questions
            .firstIndex(of: question)
        else {
            return
        }

        gatherResult(question, answer: answer)

        let nextQuestionIndex = questions.index(after: currentQuestionIndex)
        guard questions.indices.contains(nextQuestionIndex) else {
            router.routeTo(result: result)
            return
        }
        let nextQuestion = questions[nextQuestionIndex]
        router.routeTo(question: nextQuestion) {
            [unowned self] answer in
            self.routeNext(nextQuestion, answer)
        }
    }

    func gatherResult(_ question: Question, answer: Answer) {
        result[question] = answer
    }
}

// MARK: - Router

typealias Question = String
typealias Answer = String
typealias QuizResult = [Question: Answer]

// MARK: - Router

protocol Router {
    typealias AnswerCallback = (Question) -> Void
    func routeTo(question: Question, answerCallback: @escaping AnswerCallback)
    func routeTo(result: QuizResult)
}

// MARK: - FlowTests

final class FlowTests: XCTestCase {
    // MARK: - Route to Next Question

    func test_start_withNoQuestion_Should_NotRouteToQuestion() {
        let (sut, router) = makeSUT(questions: [])

        sut.start()

        XCTAssertEqual(router.routedQuestionCount, 0)
    }

    func test_start_withOneQuestion_Should_RouteToCorrectQuestion() {
        let (sut, router) = makeSUT(questions: ["Q1"])

        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withTwoQuestions_Should_RouteToFirstQuestion() {
        let (sut, router) = makeSUT(questions: ["Q1", "Q2"])

        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestions_Should_RouteToFirstQuestionTwice() {
        let (sut, router) = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }

    func test_startAndAnswerFirstQuestionWithTwoQuestion_Should_RouteToSecondQuestion() throws {
        let (sut, router) = makeSUT(questions: ["Q1", "Q2"])

        sut.start()

        router.simulateAnswer("A1")

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }
    func test_startAndAnswerFirstQuestionWithTwoQuestion_ShouldNot_RouteToResult() throws {
        let (sut, router) = makeSUT(questions: ["Q1", "Q2"])

        sut.start()

        router.simulateAnswer("A1")

        XCTAssertEqual(router.routedResults, [])
        
    }

    func test_startAndAnswerFirstAndSecondQuestionWithThreeQuestion_Should_RouteToThirdQuestion() throws {
        let (sut, router) = makeSUT(questions: ["Q1", "Q2", "Q3"])

        sut.start()

        router.simulateAnswer("A1")
        router.simulateAnswer("A2")

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }

    func test_startAndAnswerFirstQuestionWithOneQuestion_ShouldNot_RouteToAnotherQuestion() throws {
        let (sut, router) = makeSUT(questions: ["Q1"])

        sut.start()

        router.simulateAnswer("A1")

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    // MARK: - Route to Result

    func test_start_withNoQuestion_Should_RouteToResultWithEmpty() {
        let (sut, router) = makeSUT(questions: [])

        sut.start()
        let emptyQuizResult: QuizResult = [:]
        XCTAssertEqual(router.routedResults, [emptyQuizResult])
    }

    func test_startAndAnswerFirstQuestionWithOneQuestion_Should_RouteToResult() throws {
        let (sut, router) = makeSUT(questions: ["Q1"])

        sut.start()

        router.simulateAnswer("A1")

        XCTAssertEqual(router.routedResults, [
            makeResult(("Q1", "A1"))
        ])
    }

    func test_startAndAnswerFirstAndSecondQuestionWithTwoQuestion_Should_RouteToResult() throws {
        let (sut, router) = makeSUT(questions: ["Q1", "Q2"])

        sut.start()

        router.simulateAnswer("A1")
        router.simulateAnswer("A2")

        XCTAssertEqual(router.routedResults, [
            makeResult(("Q1", "A1"), ("Q2", "A2"))
        ])
    }

    // MARK: - Helper

    typealias SUT = Flow
    func makeSUT(
        questions: [Question],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (SUT, SpyRouter) {
        let router = SpyRouter()
        let sut = Flow(questions: questions, router: router)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(router, file: file, line: line)
        return (sut, router)
    }

    class SpyRouter: Router {
        var routedQuestions: [Question] = []
        var routedResults: [QuizResult] = []
        var answerCallbacks: [AnswerCallback] = []

        var routedQuestionCount: Int { routedQuestions.count }

        func routeTo(question: Question, answerCallback: @escaping AnswerCallback) {
            routedQuestions.append(question)
            answerCallbacks.append(answerCallback)
        }

        func simulateAnswer(_ answer: Question) {
            answerCallbacks.last?(answer)
        }

        func routeTo(result: QuizResult) {
            routedResults.append(result)
        }
    }

    private func makeResult(_ pairs: (Question, Answer) ...) -> QuizResult {
        var quizResult: QuizResult = [:]
        for (question, answer) in pairs {
            quizResult[question] = answer
        }
        return quizResult
    }
}
