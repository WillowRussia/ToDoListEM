//
//  ToDoRouter.swift
//  ToDoListEM
//
//  Created by Илья Востров on 28.08.2025.
//

import UIKit

class ToDoRouter {
    weak var presenter: ToDoPresenter?
    weak var navigationController: UINavigationController?
    
    static func createModule() -> UIViewController {
        let viewController = ToDoViewController()
        let interactor = ToDoInteractor()
        let presenter = ToDoPresenter()
        let router = ToDoRouter()
        
        viewController.presenter = presenter
        
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        router.presenter = presenter 
        
        interactor.presenter = presenter
        
        return viewController
    }
    
    func showEditTask(task: ToDoItem) {
        guard let navigationController = navigationController else {
            return
        }
        
        let editVC = EditTaskViewController()
        editVC.task = task
        editVC.onSave = { [weak self] updatedTask in
            guard let self = self else { return }
            
            self.presenter?.editTask(
                id: updatedTask.id,
                title: updatedTask.title,
                note: updatedTask.note,
                isCompleted: updatedTask.isCompleted
            )
        }
        
        navigationController.pushViewController(editVC, animated: true)
    }
    
    func showEditTaskForNewTask() {
        guard let navigationController = navigationController else {
            return
        }
        let editVC = EditTaskViewController()
        editVC.task = nil
        editVC.onSave = { [weak self] newTask in
            self?.presenter?.addNewTask(
                title: newTask.title,
                note: newTask.note
            )
        }
        
        navigationController.pushViewController(editVC, animated: true)
    }
}
