//
//  DHLStringTableViewCell.swift
//  DHLCustomDropDown
//
//  Created by Daniel Hernandez on 28/5/26.
//

import UIKit

class DHLStringTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var bottomLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelSeparationConstraint: NSLayoutConstraint!
    
    static let cellHeight: CGFloat = 38
    static let cellHeightTwoLines: CGFloat = 48
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // titleLabel.font = FontsHelper.normal(size: 14)
        // subtitleLabel.font = FontsHelper.normal(size: 14)
        bottomLineHeightConstraint.constant = 0.5
    }
    
    func setUp(title: String, subtitle: String? = nil, hideSeparator: Bool = false) {
        titleLabel.text = title
        
        if let subtitle = subtitle {
            // titleLabel.font = FontsHelper.semiBold(size: 14)
            subtitleLabel.text = subtitle
            labelSeparationConstraint.constant = -2
        } else {
            // titleLabel.font = FontsHelper.normal(size: 14)
            subtitleLabel.text = ""
            labelSeparationConstraint.constant = 0
        }
        
        if hideSeparator {
            separatorView.isHidden = true
        } else {
            separatorView.isHidden = false
        }
    }
}
