import XCTest
class Flow {
    let router: Router
    let questions: [String]
    
    init(questions: [String], router: Router) {
        self.router = router
        self.questions = questions
    }
    
    func start() {
        if questions.isEmpty {return}
        router.routeTo(question: questions.first!)
    }
}
protocol Router {
    func routeTo(question: String)
}

class SpyRouter: Router {
    var routedQuestionCount: Int {routedQuestions.count}
    var routedQuestions:[String] = []
    
    func routeTo(question: String) {
        routedQuestions.append(question)
    }
}


final class FlowTests: XCTestCase {
    func test_start_withNoQuestion_Should_NotRouteToQuestion() {
        let router = SpyRouter()
        let sut = Flow(questions: [], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestionCount, 0)
    }
    
    func test_start_withOneQuestion_Should_RouteToQuestion() {
        let router = SpyRouter()
        let sut = Flow(questions: ["Q1"], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestionCount, 1)
    }
    func test_start_withTwoQuestions_Should_RouteToFirstQuestion() {
        let router = SpyRouter()
        let sut = Flow(questions: ["Q1", "Q2"], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
}

