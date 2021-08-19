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
        router.routeTo(question: "any question")
    }
}
protocol Router {
    func routeTo(question: String)
}

class SpyRouter: Router {
    var routedQuestionCount = 0
    func routeTo(question: String) {
        routedQuestionCount += 1
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
}

