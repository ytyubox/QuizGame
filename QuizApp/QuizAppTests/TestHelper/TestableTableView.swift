//
/*
 *		Created by 游宗諭 in 2021/8/22
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 12.0
 */

import UIKit
protocol TestableTableView {
    var tableView: UITableView { get }
    func cell(at row: Int) -> UITableViewCell?

    func title(at row: Int) -> String?

    func numberOfCell() -> Int

    func select(at row: Int)

    func deselect(at row: Int)
}

extension TestableTableView {
    var optionSection: Int { 0 }
    func cell(at row: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: row, section: optionSection)
        return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }

    func title(at row: Int) -> String? {
        cell(at: row)?.textLabel?.text
    }

    func numberOfCell() -> Int {
        tableView.numberOfRows(inSection: optionSection)
    }

    func select(at row: Int) {
        let indexPath = IndexPath(row: row, section: optionSection)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }

    func deselect(at row: Int) {
        let indexPath = IndexPath(row: row, section: optionSection)
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
}
