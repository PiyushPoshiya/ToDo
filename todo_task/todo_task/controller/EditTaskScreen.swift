//
//  EditTaskScreen.swift
//  todo_task
//
//  Created by Piyush on 21/04/25.
//

import UIKit

protocol EditTaskViewControllerDelegate: AnyObject {
    func todoViewController(_ vc: EditTaskScreen, didSaveTodo todo: Task)
}

class EditTaskScreen: UIViewController {
    
    //MARK: @IBOutlet
    
    @IBOutlet weak var textfield: UITextField!
    
    var todo: Task?
    weak var delegate: EditTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if todo?.title != ""
        {
            textfield.text = todo?.title
        }
        textfield.tintColor = PrimaryColor
        textfield.textColor = PrimaryColor
    }
}

//MARK: Button Action

extension EditTaskScreen
{
    @IBAction func save(_ sender: Any) {
        
        print("text---\(textfield.text!)")
        if textfield.text! == ""
        {
            showAlertMsg(Message: ENTER_TODO_MSG, AutoHide: false)
        }
        else
        {
            let todo = Task(title: textfield.text!)
            delegate?.todoViewController(self, didSaveTodo: todo)
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
