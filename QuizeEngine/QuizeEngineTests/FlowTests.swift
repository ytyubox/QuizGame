import XCTest
class Flow {
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {}
}
protocol Router {
}
    class SpyRouter: Router {
    let routedQuestionCount = 0
}


final class FlowTests: XCTestCase {
    func test_start_withNoQuestion_Should_NotRouteToQuestion() {
        let router = SpyRouter()
        let sut = Flow(router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestionCount, 0)
    }
}

