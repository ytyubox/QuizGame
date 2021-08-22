//
/*
 *		Created by 游宗諭 in 2021/8/22
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 12.0
 */

import UIKit
extension UITableView {
    func register(_ type: UITableViewCell.Type) {
        register(type.self, forCellReuseIdentifier: "\(type)")
    }

    func dequeueReusableCell<Cell: UITableViewCell>(_ type: Cell.Type, for indexPath: IndexPath) -> Cell {
        dequeueReusableCell(withIdentifier: "\(type)", for: indexPath) as! Cell
    }
}
