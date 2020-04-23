//
//  AnimationSettingsViewController.swift
//  DuckDuckGo
//
//  Created by Christopher Brind on 23/04/2020.
//  Copyright © 2020 DuckDuckGo. All rights reserved.
//

import UIKit

class AnimationSettingsViewController: UITableViewController {

    @IBOutlet weak var fireCell: UITableViewCell!
    @IBOutlet weak var lightningCell: UITableViewCell!

    let settings = AnimationSettings()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateCells()
        applyTheme(ThemeManager.shared.currentTheme)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settings.animation = indexPath.row * -1
        updateCells()
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let theme = ThemeManager.shared.currentTheme
        cell.backgroundColor = theme.tableCellBackgroundColor
        cell.setHighlightedStateBackgroundColor(theme.tableCellHighlightedBackgroundColor)
        cell.textLabel?.textColor = theme.tableCellTextColor

    }

    func updateCells() {
        fireCell.accessoryType = settings.animation >= 0 ? .checkmark : .none
        lightningCell.accessoryType = settings.animation < 0 ? .checkmark : .none
    }

}

extension AnimationSettingsViewController: Themable {
    func decorate(with theme: Theme) {
        decorateNavigationBar(with: theme)
        tableView.backgroundColor = theme.backgroundColor
        tableView.separatorColor = theme.tableCellSeparatorColor

    }
}
