import XCTest

// MARK: - Flow

class Flow {
    let router: Router
    let questions: [String]
    
    init(questions: [String], router: Router) {
        self.router = router
        self.questions = questions
    }
    
    func start() {
        guard let firstQuestion = questions.first else { return }
        router.routeTo(question: firstQuestion)
    }
}

// MARK: - Router

protocol Router {
    func routeTo(question: String)
}

// MARK: - FlowTests

final class FlowTests: XCTestCase {
    func test_start_withNoQuestion_Should_NotRouteToQuestion() {
        let router = SpyRouter()
        let sut = Flow(questions: [], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestionCount, 0)
    }
    
    func test_start_withOneQuestion_Should_RouteToCorrectQuestion() {
        let router = SpyRouter()
        let sut = Flow(questions: ["Q1"], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withTwoQuestions_Should_RouteToFirstQuestion() {
        let router = SpyRouter()
        let sut = Flow(questions: ["Q1", "Q2"], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_Should_RouteToFirstQuestionTwice() {
        let router = SpyRouter()
        let sut = Flow(questions: ["Q1", "Q2"], router: router)
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    // MARK: - Helper
    
    class SpyRouter: Router {
        var routedQuestionCount: Int { routedQuestions.count }
        var routedQuestions: [String] = []
        
        func routeTo(question: String) {
            routedQuestions.append(question)
        }
    }
}
