//
/*
 *		Created by 游宗諭 in 2021/8/22
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 12.0
 */

import UIKit
class ResultViewController: UIViewController, UITableViewDataSource {
    private var summary = ""
    private var answers: [PresentableAnswer] = []
    convenience init(summary: String, answers: [PresentableAnswer]) {
        self.init()
        self.summary = summary
        self.answers = answers
    }

    let headerLabel = UILabel()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = summary
        tableView.dataSource = self
        tableView.register(CorrectAnswerCell.self)
        tableView.register(WrongAnswerCell.self)
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        answers.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        if answer.isCorrect {
            return correctCell(for: answer, indexPath: indexPath)
        } else {
            return wrongAnswerCell(for: answer, indexPath: indexPath)
        }
    }

    private func correctCell(for answer: PresentableAnswer, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CorrectAnswerCell.self, for: indexPath)
        cell.questionLabel.text = answer.question
        cell.answerLabel.text = answer.answer
        return cell
    }

    private func wrongAnswerCell(for answer: PresentableAnswer, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WrongAnswerCell.self, for: indexPath)
        cell.questionLabel.text = answer.question
        cell.correctAnswerLabel.text = answer.answer
        cell.wrongAnswerLabel.text = answer.wrongAnswer
        return cell
    }
}
