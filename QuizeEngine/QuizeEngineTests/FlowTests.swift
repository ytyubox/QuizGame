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
        guard let firstQuestion = questions.first else { return }
        router.routeTo(question: firstQuestion) { answer in
            guard
                let firstQuestionIndex = self.questions.firstIndex(of: firstQuestion)
            else {return}
            let nextQuestionIndex = self.questions.index(after: firstQuestionIndex)
            let nextQuestion = self.questions[nextQuestionIndex]
            self.router.routeTo(question: nextQuestion) { _ in
                
            }
        }
    }
}

// MARK: - Router

typealias Question = String

protocol Router {
    typealias AnswerCallback = (Question) -> Void
    func routeTo(question: Question, answerCallback: @escaping AnswerCallback)
}

// MARK: - FlowTests

final class FlowTests: XCTestCase {
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
        let (sut, router) = makeSUT(questions: ["Q1" , "Q2"])
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_Should_RouteToFirstQuestionTwice() {
        let (sut, router) = makeSUT(questions: ["Q1" , "Q2"])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstQuestionWithTwoQuestion_Should_RouteToSecondQuestion() throws {
        let (sut, router) = makeSUT(questions: ["Q1" , "Q2"])
        
        
        sut.start()
        
        router.simulateAnswer("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }
    
    // MARK: - Helper
    
    typealias SUT = Flow
    func makeSUT(
        questions: [Question],
        file: StaticString = #filePath,
        line: UInt = #line) -> (SUT, SpyRouter)
    {
        let router = SpyRouter()
        let sut = Flow(questions: questions, router: router)
        return (sut, router)
    }
    
    class SpyRouter: Router {
        var routedQuestions: [Question] = []
        var answerCallbacks:[AnswerCallback] = []
        
        var routedQuestionCount: Int { routedQuestions.count }
        
        func routeTo(question: Question, answerCallback: @escaping AnswerCallback) {
            routedQuestions.append(question)
            answerCallbacks.append(answerCallback)
        }
        
        func simulateAnswer(_ answer: Question) {
            answerCallbacks.first?(answer)
        }
    }
}
