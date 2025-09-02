protocol ToDoInteractorOutput: AnyObject {
    func didFetchTasks(_ tasks: [ToDoItem])
    func didAddTask()
    func didUpdateTask()
    func didDeleteTask()
    func didFailWithError(_ error: String)
}