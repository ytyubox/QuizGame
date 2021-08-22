public class Flow {
    let router: Router
    let questions: [Question]
    private var result: [Question: Answer] = [:]

    public init(questions: [Question], router: Router) {
        self.router = router
        self.questions = questions
    }

    public func start() {
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

    private func gatherResult(_ question: Question, answer: Answer) {
        result[question] = answer
    }
}
