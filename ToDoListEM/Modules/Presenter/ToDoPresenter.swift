class ToDoPresenter: ToDoViewOutput, ToDoInteractorOutput {
    weak var view: ToDoViewInput?
    var interactor: ToDoInteractor?
    var router: ToDoRouter?
    
    private var tasks: [ToDoItem] = []
    
    func viewDidLoad() {
        interactor?.fetchAllTasks()
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "API_Loaded") {
            interactor?.loadTasksFromAPI()
            defaults.set(true, forKey: "API_Loaded")
        }
    }
    
    func addNewTask(title: String, note: String) {
        interactor?.addTask(title: title, note: note)
    }
    
    func editTask(id: Int, title: String, note: String, isCompleted: Bool) {
        interactor?.editTask(id: id, title: title, note: note, isCompleted: isCompleted)
    }
    
    func deleteTask(id: Int) {
        interactor?.deleteTask(id: id)
    }
    
    func toggleTaskStatus(id: Int) {
        interactor?.toggleTaskStatus(id: id)
    }
    
    func searchTasks(query: String) {
        if query.isEmpty {
            interactor?.fetchAllTasks()
        } else {
            interactor?.searchTasks(query: query)
        }
    }
    
    // MARK: - Interactor Output
    func didFetchTasks(_ tasks: [ToDoItem]) {
        self.tasks = tasks
        DispatchQueue.main.async {
            self.view?.reloadTableView()
        }
    }
    
    func didAddTask() {
        interactor?.fetchAllTasks()
    }
    
    func didUpdateTask() {
        interactor?.fetchAllTasks()
    }
    
    func didDeleteTask() {
        interactor?.fetchAllTasks()
    }
    
    func didFailWithError(_ error: String) {
        DispatchQueue.main.async {
            self.view?.showError(error)
        }
    }
}