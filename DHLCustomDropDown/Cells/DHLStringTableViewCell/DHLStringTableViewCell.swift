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
        bottomLineHeightConstraint.constant = 0.5
    }
    
    func setUp(title: String, subtitle: String? = nil, hideSeparator: Bool = false, titleFont: UIFont? = nil, subtitleFont: UIFont? = nil) {
        titleLabel.text = title
        
        titleLabel.font = titleFont ?? .systemFont(ofSize: 14)
        subtitleLabel.font = subtitleFont ?? .systemFont(ofSize: 14)
        
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
            labelSeparationConstraint.constant = -2
        } else {
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
