//
//  HomeScreen.swift
//  todo_task
//
//  Created by Piyush on 21/04/25.
//

import UIKit

class HomeScreen: UIViewController {
    
    //MARK: @IBOutlet

    @IBOutlet weak var tableView: UITableView!
    
    var taskArr: [Task] = []

    let noDataView = NoDataView(message: "You don't have any tasks yet!", image: UIImage(systemName: "list.bullet.rectangle"))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    func setUI()
    {
        view.addSubview(noDataView)
        noDataView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            noDataView.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            noDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        noDataView.isHidden = true
        self.updateUIBasedOnData()
    }
    
    func updateUIBasedOnData() {
        
        taskArr = UserDefaultManager.loadTasks()
        
        let hasData = taskArr.count > 0
        noDataView.isHidden = hasData
        tableView.isHidden = !hasData
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
    }

    @IBAction func btnAddTodo(_ sender: Any) {
        self.presentEditTask(isEdit: false)
    }
    
    func presentEditTask(isEdit: Bool)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditTaskScreen") as? EditTaskScreen

        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen

        if isEdit == true
        {
            if let indexpath = tableView.indexPathForSelectedRow {
              let todo = taskArr[indexpath.row]
              vc?.todo = todo
            }
            vc?.delegate = self
        }
        else
        {
            let task: Task = Task(title: "")
            vc?.todo = task
        }
        vc?.presentationController?.delegate = self
        
        self.present(vc!, animated: true, completion: nil)
    }
}

extension HomeScreen: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Complete") { action, view, complete in
            
            let todo = self.taskArr[indexPath.row].completeToggled()
            self.taskArr[indexPath.row] = todo
            
            let cell = tableView.cellForRow(at: indexPath) as! TaskTblCell
            cell.set(checked: todo.isComplete)
            
            complete(true)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}

//MARK: UITableView DataSource Method

extension HomeScreen: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTblCell", for: indexPath) as! TaskTblCell
        
        cell.delegate = self
        
        let todo = taskArr[indexPath.row]
        cell.set(title: todo.title, checked: todo.isComplete)
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.onClickbtnDelete(_:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteConfirmation(for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = taskArr.remove(at: sourceIndexPath.row)
        taskArr.insert(todo, at: destinationIndexPath.row)
    }
    
    @objc func onClickbtnDelete(_ sender:UIButton) {
        
        showDeleteConfirmation(for: IndexPath(row: sender.tag, section: 0))
    }

}

extension HomeScreen: TaskTableViewCellDelegate {
    func taskTableViewCell(_ cell: TaskTblCell, didChagneCheckedState checked: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let todo = taskArr[indexPath.row]
        let newTodo = Task(title: todo.title, isComplete: checked)
        
        taskArr[indexPath.row] = newTodo
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentEditTask(isEdit: true)
    }
}

extension HomeScreen: EditTaskViewControllerDelegate {
  
    func todoViewController(_ vc: EditTaskScreen, didSaveTodo todo: Task) {
    
        dismiss(animated: true) {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // update
                self.taskArr[indexPath.row] = todo
                self.tableView.reloadRows(at: [indexPath], with: .none)
                UserDefaultManager.saveTasksToUserDefaults(self.taskArr)
                self.updateUIBasedOnData()
            } else {
                // create
                self.taskArr.append(todo)
                self.tableView.insertRows(at: [IndexPath(row: self.taskArr.count-1, section: 0)], with: .automatic)
                UserDefaultManager.saveTasksToUserDefaults(self.taskArr)
                self.updateUIBasedOnData()
            }
        }
  }
  
}


extension HomeScreen: UIAdaptivePresentationControllerDelegate {
  
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
}

extension HomeScreen
{
    func showDeleteConfirmation(for indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Delete Task",
            message: "Are you sure you want to delete this task?",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.taskArr.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            UserDefaultManager.saveTasksToUserDefaults(self.taskArr)
            self.updateUIBasedOnData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }
}
