import UIKit

// MARK: - QuestionViewController

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var question: String = ""
    private var options: [String] = []
    private var selection: (([String]) -> Void)?
    let headerLabel = UILabel()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()

    static let cellReuseIdentifier = "Cell"
    convenience init(question: String, options: [String], selection: @escaping ([String]) -> Void) {
        self.init()
        self.question = question
        self.options = options
        self.selection = selection
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = question
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt _: IndexPath) {
        selectedOptions(in: tableView)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt _: IndexPath) {
        guard tableView.allowsMultipleSelection else { return }
        selectedOptions(in: tableView)
    }

    private func selectedOptions(in tableView: UITableView) {
        let selectedIndexPath = tableView.indexPathsForSelectedRows ?? []
        let selectedOptions = selectedIndexPath.map { options[$0.row] }
        selection?(selectedOptions)
    }
}
