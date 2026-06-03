//
//  DHLCustomDropDown.swift
//  DHLCustomDropDown
//
//  Created by Daniel Hernandez on 28/5/26.
//

import Foundation
import UIKit

open class DHLCustomDropDown: UIView {

    @IBOutlet public weak var containerView: UIView!
    
    @IBOutlet weak var separatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightContraint: NSLayoutConstraint!
    
    @IBOutlet public weak var dropDownButton: UIButton!
    @IBOutlet public weak var dropDownTitle: UILabel!
    @IBOutlet public weak var arrowImageView: UIImageView!
    
    @IBOutlet public weak var tableView: UITableView!
    
    private var itemSelectedAction: ((String, Int) -> Void)?
    
    public var selectionType: SelectionType = .single
    private var title: String = ""
    
    public var items: [String] = []
    public var itemSubtitles: [String]?
    private var heightLimit: CGFloat?
    private var accessibilityTitleLabel: String?
    private var cellTitleFont: UIFont? = nil
    private var cellSubtitleFont: UIFont? = nil
    private var arrowTintColor: UIColor = .black
    
    public var selectedItem: [String] = []
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        nibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        nibSetup()
    }

    private func nibSetup() {

        backgroundColor = .clear

        let bundle = Bundle(for: DHLCustomDropDown.self)

        if let xibView = bundle.loadNibNamed("DHLCustomDropDown",
                                             owner: self,
                                             options: nil)?.first as? UIView {

            xibView.frame = self.bounds
            xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(xibView)

            commonInit()
        }
    }

    public override func awakeFromNib() {

        super.awakeFromNib()

        commonInit()
    }

    open func commonInit() {
        // la altura de la vista se calcula automaticamente, en el storyboard hay que poner una altura con baja prioridad o placeholder/"remove at build time".
        tableViewHeightContraint.constant = 0
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 0.5
        
        tableView.register(UINib(nibName: "DHLStringTableViewCell", bundle: Bundle(for: DHLStringTableViewCell.self)), forCellReuseIdentifier: "DHLStringTableViewCell")
        
        separatorHeightConstraint.constant = 0.5
        
        dropDownButton.accessibilityLabel = ""
        dropDownTitle.isAccessibilityElement = false
    }

    public func setUp(title: String, accessibilityTitleLabel: String? = nil, items: [String], itemSubtitles: [String]? = nil, selectionType: SelectionType = .single, heightLimit: CGFloat? = nil, titleFont: UIFont? = nil, cellTitleFont: UIFont? = nil, cellSubtitleFont: UIFont? = nil, arrowTintColor: UIColor = .black, itemSelectedAction: @escaping ((String, Int) -> Void)) {
        self.items = items
        self.itemSubtitles = itemSubtitles
        self.selectionType = selectionType
        self.title = title
        self.heightLimit = heightLimit
        self.itemSelectedAction = itemSelectedAction
        self.accessibilityTitleLabel = accessibilityTitleLabel
        self.cellTitleFont = cellTitleFont
        self.cellSubtitleFont = cellSubtitleFont
        self.arrowTintColor = arrowTintColor
        
        arrowImageView.image = UIImage(named: "arrow_down", in: Bundle(for: DHLCustomDropDown.self), compatibleWith: nil)!.withTintColor(arrowTintColor)
        
        dropDownTitle.font = titleFont ?? .systemFont(ofSize: 14)
        
        dropDownButton.accessibilityLabel = (accessibilityTitleLabel ?? title)
            .appending(NSLocalizedString("dropdown", tableName: "Strings", bundle: Bundle(for: DHLCustomDropDown.self), comment: ""))
            .appending(String(
                format: NSLocalizedString(
                    "elements_number",
                    tableName: "Strings",
                    bundle: Bundle(for: DHLCustomDropDown.self),
                    comment: ""
                ),
                items.count
                )
            )
        
        tableViewHeightContraint.constant = 0
        dropDownTitle.text = title
        
        if selectionType == .single {
            tableView.allowsMultipleSelection = false
        } else {
            tableView.allowsMultipleSelection = true
        }
        
        reloadData()
    }
    
    public func deselectAllItems() {
        dropDownTitle.text = title
        dropDownTitle.textColor = UIColor.lightGray
        selectedItem = []
        
        tableView.deselectAllRows(animated: false)
    }
    
    public func reloadData() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    public func selectItem(itemToSelect: String) {
        if let index = items.firstIndex(where: { $0.lowercased() == itemToSelect.lowercased() }) {
            
            let indexPath = IndexPath(row: index, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
    
    @IBAction func dropDownPressed(_ sender: Any) {
        if tableViewHeightContraint.constant == 0 {
            arrowImageView.image = UIImage(named: "arrow_up", in: Bundle(for: DHLCustomDropDown.self), compatibleWith: nil)!.withTintColor(arrowTintColor)
            
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
            arrowImageView.image = UIImage(named: "arrow_down", in: Bundle(for: DHLCustomDropDown.self), compatibleWith: nil)!.withTintColor(arrowTintColor)
        }
    }
}

// ********************************************
// MARK: - UITableView Delegate & Datasource
// ********************************************
extension DHLCustomDropDown: UITableViewDelegate, UITableViewDataSource {

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DHLStringTableViewCell", for: indexPath) as? DHLStringTableViewCell {
            
            if itemSubtitles != nil {
                cell.setUp(title: items[indexPath.row], subtitle: itemSubtitles![indexPath.row], titleFont: cellTitleFont, subtitleFont: cellSubtitleFont)
                
            } else {
                cell.setUp(title: items[indexPath.row], titleFont: cellTitleFont, subtitleFont: cellSubtitleFont)
            }
            
            if selectionType == .single {
                cell.selectionStyle = .none
            }
            
           
            cell.titleLabel.accessibilityLabel = String(
                format: NSLocalizedString(
                    "description_element_number_of",
                    tableName: "Strings",
                    bundle: Bundle(for: DHLCustomDropDown.self),
                    comment: ""
                ),
                items[indexPath.row],
                indexPath.row + 1,
                items.count
            )
            
            return cell
        }
        return UITableViewCell()
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if itemSubtitles != nil {
            return DHLStringTableViewCell.cellHeightTwoLines
        }
        return DHLStringTableViewCell.cellHeight
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionType == .single {
            
            selectedItem = [items[indexPath.row]]
            dropDownTitle.text = selectedItem.first
            dropDownTitle.textColor = .black
            
            tableViewHeightContraint.constant = 0
            
            arrowImageView.image = UIImage(named: "arrow_down", in: Bundle(for: DHLCustomDropDown.self), compatibleWith: nil)!.withTintColor(arrowTintColor)
            
            if let selectedItem = selectedItem.first {
                itemSelectedAction?(selectedItem, indexPath.row)
                
                dropDownButton.accessibilityLabel = (accessibilityTitleLabel ?? title)
                    .appending(NSLocalizedString("dropdown", tableName: "Strings", bundle: Bundle(for: DHLCustomDropDown.self), comment: ""))
                    .appending(String(
                        format: NSLocalizedString(
                            "elements_number",
                            tableName: "Strings",
                            bundle: Bundle(for: DHLCustomDropDown.self),
                            comment: ""
                        ),
                        items.count
                        )
                    )
                    .appending(String(
                        format: NSLocalizedString(
                            "item_selected",
                            tableName: "Strings",
                            bundle: Bundle(for: DHLCustomDropDown.self),
                            comment: ""
                        ),
                        selectedItem
                        )
                    )
                
                UIAccessibility.post(notification: .layoutChanged, argument: self)
            }
            
        } else {
            selectedItem.append(items[indexPath.row])
            dropDownTitle.text = selectedItem.joined(separator: ", ")
            dropDownTitle.textColor = .black
            
            dropDownButton.accessibilityLabel = (accessibilityTitleLabel ?? title)
                .appending(NSLocalizedString("dropdown", tableName: "Strings", bundle: Bundle(for: DHLCustomDropDown.self), comment: ""))
                .appending(String(
                    format: NSLocalizedString(
                        "elements_number",
                        tableName: "Strings",
                        bundle: Bundle(for: DHLCustomDropDown.self),
                        comment: ""
                    ),
                    items.count
                    )
                )
                .appending(String(
                    format: NSLocalizedString(
                        "item_selected",
                        tableName: "Strings",
                        bundle: Bundle(for: DHLCustomDropDown.self),
                        comment: ""
                    ),
                    selectedItem.joined(separator: ", ")
                    )
                )
            
            if selectedItem.isEmpty {
                dropDownTitle.textColor = UIColor.lightGray
                            
                dropDownButton.accessibilityLabel = (accessibilityTitleLabel ?? title)
                    .appending(NSLocalizedString("dropdown", tableName: "Strings", bundle: Bundle(for: DHLCustomDropDown.self), comment: ""))
                    .appending(String(
                        format: NSLocalizedString(
                            "elements_number",
                            tableName: "Strings",
                            bundle: Bundle(for: DHLCustomDropDown.self),
                            comment: ""
                        ),
                        items.count
                        )
                    )
            }
        }
    }
    
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if selectionType == .multiple {
            
            selectedItem.removeFirst(where: { $0 == items[indexPath.row] })
            
            dropDownTitle.text = selectedItem.joined(separator: ", ")
            dropDownTitle.textColor = .black
            
            if selectedItem.isEmpty {
                dropDownTitle.textColor = UIColor.lightGray
                dropDownTitle.text = title
            }
        }
    }
}

public enum SelectionType {
    case single
    case multiple
}

extension UITableView {
    func deselectAllRows(animated: Bool) {
        guard let selectedRows = indexPathsForSelectedRows else { return }
        for indexPath in selectedRows { deselectRow(at: indexPath, animated: animated) }
    }
}

// ********************************************
// MARK: - RangeReplaceableCollection
// ********************************************
 extension RangeReplaceableCollection {
    @discardableResult
    mutating func removeFirst(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        guard let index = try firstIndex(where: predicate) else { return nil }
        return remove(at: index)
    }
}
