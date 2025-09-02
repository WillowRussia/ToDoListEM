class ToDoRouter {
    weak var presenter: ToDoPresenter?
    
    static func createModule() -> ToDoViewController {
        let view = ToDoViewController()
        let interactor = ToDoInteractor()
        let presenter = ToDoPresenter()
        let router = ToDoRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        return view
    }
    
    func showEditTask(task: ToDoItem) {
        let editVC = EditTaskViewController()
        editVC.task = task
        editVC.onSave = { [weak self] updatedTask in
            self?.presenter?.editTask(
                id: updatedTask.id,
                title: updatedTask.title,
                note: updatedTask.note,
                isCompleted: updatedTask.isCompleted
            )
        }
        UIApplication.shared.windows.first?.rootViewController?.present(editVC, animated: true)
    }
}