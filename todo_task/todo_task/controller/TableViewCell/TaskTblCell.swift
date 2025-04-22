//
//  TaskTblCell.swift
//  todo_task
//
//  Created by Piyush on 21/04/25.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
  func taskTableViewCell(_ cell: TaskTblCell, didChagneCheckedState checked: Bool)
}

class TaskTblCell: UITableViewCell {

    //MARK: @IBOutlet
    
    @IBOutlet weak var checkbox: Checkbox!
    @IBOutlet weak var lblTask: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    weak var delegate: TaskTableViewCellDelegate?

    
    @IBAction func checked(_ sender: Checkbox) {
      updateChecked()
      delegate?.taskTableViewCell(self, didChagneCheckedState: checkbox.checked)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(title: String, checked: Bool) {
        lblTask.text = title
      set(checked: checked)
    }
    
    func set(checked: Bool) {
      checkbox.checked = checked
      updateChecked()
    }
    
    private func updateChecked() {
      let attributedString = NSMutableAttributedString(string: lblTask.text!)
      
      if checkbox.checked {
        attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length-1))
      } else {
        attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length-1))
      }
      
        lblTask.attributedText = attributedString
    }

}
