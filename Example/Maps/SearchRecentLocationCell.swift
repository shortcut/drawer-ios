//
//  SearchRecentLocationCell.swift
//  Maps
//
//  Created by Denis Dzyubenko on 16/03/2020.
//  Copyright © 2020 Shortcut. All rights reserved.
//

import UIKit

class SearchRecentLocationCell: UITableViewCell {
    var iconColor: UIColor? {
        didSet {
            iconView.backgroundColor = iconColor
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
        }
    }

    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
}
