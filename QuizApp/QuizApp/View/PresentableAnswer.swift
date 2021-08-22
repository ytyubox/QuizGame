struct PresentableAnswer {
    let question: String
    let answer: String
    let wrongAnswer: String?
    var isCorrect: Bool { wrongAnswer == nil }
}
