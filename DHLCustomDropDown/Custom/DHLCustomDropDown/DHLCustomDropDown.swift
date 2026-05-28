//
//  DHLCustomDropDown.swift
//  DHLCustomDropDown
//
//  Created by Daniel Hernandez on 28/5/26.
//

import Foundation
import UIKit

class CustomDropDown: UIView {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var separatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var dropDownTitle: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var itemSelectedAction: ((String, Int) -> Void)?
    
    var selectionType: SelectionType = .single
    private var title: String = ""
    
    var items: [String] = []
    var itemSubtitles: [String]?
    private var heightLimit: CGFloat?
    private var accessibilityTitleLabel: String?

    var selectedItem: [String] = []
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        nibSetup()
    }

    private func nibSetup() {

        backgroundColor = .clear

        if let xibView = Bundle.main.loadNibNamed("CustomDropDown", owner: self, options: nil)?.first as? UIView {

            xibView.frame = self.bounds
            xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(xibView)

            commonInit()
        }
    }

    override func awakeFromNib() {

        super.awakeFromNib()

        commonInit()
    }

    func commonInit() {
        // la altura de la vista se calcula automaticamente, en el storyboard hay que poner una altura con baja prioridad o placeholder/"remove at build time".
        tableViewHeightContraint.constant = 0
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 0.5
        // containerView.bordered(width: 0.5, color: R.color.gray_border())
        
        tableView.register(UINib(nibName: "StringTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "StringTableViewCell")
        
        // dropDownTitle.font = FontsHelper.normal(size: 14)
        
        separatorHeightConstraint.constant = 0.5
        
        // arrowImageView.image = R.image.arrow_down()!.tinted(withColor: R.color.blue_app())
        
        dropDownButton.accessibilityLabel = ""
        dropDownTitle.isAccessibilityElement = false
    }

    func setUp(title: String, accessibilityTitleLabel: String? = nil, items: [String], itemSubtitles: [String]? = nil, selectionType: SelectionType = .single, heightLimit: CGFloat? = nil, itemSelectedAction: @escaping ((String, Int) -> Void)) {
        self.items = items
        self.itemSubtitles = itemSubtitles
        self.selectionType = selectionType
        self.title = title
        self.heightLimit = heightLimit
        self.itemSelectedAction = itemSelectedAction
        self.accessibilityTitleLabel = accessibilityTitleLabel
        
        // dropDownButton.accessibilityLabel = (accessibilityTitleLabel ?? title).appending(R.string.accessibility.dropdown()).appending(R.string.accessibility.elements_number(items.count))
        
        tableViewHeightContraint.constant = 0
        dropDownTitle.text = title
        
        if selectionType == .single {
            tableView.allowsMultipleSelection = false
        } else {
            tableView.allowsMultipleSelection = true
        }
        
        reloadData()
    }
    
    func deselectAllItems() {
        dropDownTitle.text = title
        // dropDownTitle.textColor = R.color.gray_app()
        selectedItem = []
        
        // tableView.deselectAllRows(animated: false)
    }
    
    func reloadData() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func selectItem(itemToSelect: String) {
        if let index = items.firstIndex(where: { $0.lowercased() == itemToSelect.lowercased() }) {
            
            let indexPath = IndexPath(row: index, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
    
    @IBAction func dropDownPressed(_ sender: Any) {
        if tableViewHeightContraint.constant == 0 {
            // arrowImageView.image = R.image.arrow_up()!.tinted(withColor: R.color.blue_app())
            
            var cellsHeight: CGFloat = DHLStringTableViewCell.cellHeight * CGFloat(items.count)
            
            if itemSubtitles != nil {
                cellsHeight = DHLStringTableViewCell.cellHeightTwoLines * CGFloat(items.count)
            }
            
            if let heightLimit = heightLimit {
                
                if cellsHeight < heightLimit {
                    tableViewHeightContraint.constant = cellsHeight
                    
                } else {
                    tableViewHeightContraint.constant = heightLimit
                }
                
            } else {
                tableViewHeightContraint.constant = cellsHeight
            }
            
        } else {
            tableViewHeightContraint.constant = 0
            // arrowImageView.image = R.image.arrow_down()!.tinted(withColor: R.color.blue_app())
        }
    }
}

// ********************************************
// MARK: - UITableView Delegate & Datasource
// ********************************************
extension CustomDropDown: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DHLStringTableViewCell", for: indexPath) as? DHLStringTableViewCell {
            
            if itemSubtitles != nil {
                cell.setUp(title: items[indexPath.row], subtitle: itemSubtitles![indexPath.row])
                
            } else {
                cell.setUp(title: items[indexPath.row])
            }
            
            if selectionType == .single {
                cell.selectionStyle = .none
            }
            
            // cell.titleLabel.accessibilityLabel = R.string.accessibility.description_element_number_of(items[indexPath.row], indexPath.row + 1, items.count)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if itemSubtitles != nil {
            return DHLStringTableViewCell.cellHeightTwoLines
        }
        return DHLStringTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionType == .single {
            
            selectedItem = [items[indexPath.row]]
            dropDownTitle.text = selectedItem.first
            dropDownTitle.textColor = .black
            
            tableViewHeightContraint.constant = 0
            
            // arrowImageView.image = R.image.arrow_down()!.tinted(withColor: R.color.blue_app())
            
            if let selectedItem = selectedItem.first {
                itemSelectedAction?(selectedItem, indexPath.row)
                
                // dropDownButton.accessibilityLabel = (accessibilityTitleLabel ?? title).appending(R.string.accessibility.dropdown()).appending(R.string.accessibility.elements_number(items.count)).appending(R.string.accessibility.item_selected(selectedItem))
                UIAccessibility.post(notification: .layoutChanged, argument: self)
            }
            
        } else {
            selectedItem.append(items[indexPath.row])
            dropDownTitle.text = selectedItem.joined(separator: ", ")
            dropDownTitle.textColor = .black
            
            // dropDownButton.accessibilityLabel = (accessibilityTitleLabel ?? title).appending(R.string.accessibility.dropdown()).appending(R.string.accessibility.elements_number(items.count)).appending(R.string.accessibility.item_selected(selectedItem.joined(separator: ", ")))
            
            if selectedItem.isEmpty {
               // dropDownTitle.textColor = R.color.gray_app()
                
               // dropDownButton.accessibilityLabel = (accessibilityTitleLabel ?? title).appending(R.string.accessibility.dropdown()).appending(R.string.accessibility.elements_number(items.count))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if selectionType == .multiple {
            
            // selectedItem.removeFirst(where: { $0 == items[indexPath.row] })
            
            dropDownTitle.text = selectedItem.joined(separator: ", ")
            dropDownTitle.textColor = .black
            
            if selectedItem.isEmpty {
                // dropDownTitle.textColor = R.color.gray_app()
                dropDownTitle.text = title
            }
        }
    }
}

enum SelectionType {
    case single
    case multiple
}
