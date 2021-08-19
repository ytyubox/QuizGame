import XCTest

// MARK: - Flow

class Flow {
    let router: Router
    let questions: [Question]

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
            [unowned self] _ in
            routeNext(firstQuestion)
        }
    }

    private func routeNext(_ question: Question) {
        guard let currentQuestionIndex = questions
            .firstIndex(of: question)
        else {
            return
        }
        let nextQuestionIndex = questions.index(after: currentQuestionIndex)
        guard questions.indices.contains(nextQuestionIndex) else {
            return
        }
        let nextQuestion = questions[nextQuestionIndex]
        router.routeTo(question: nextQuestion) { [unowned self] _ in
            self.routeNext(nextQuestion)
        }
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

    func test_start_withNoQuestion_Should_NotRouteToResult() {
        let (sut, router) = makeSUT(questions: [])

        sut.start()
        let emptyQuizResult:QuizResult = [:]
        XCTAssertEqual(router.routedResults, [emptyQuizResult])
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
        var routedResults:[QuizResult] = []
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
}
