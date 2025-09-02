protocol ToDoViewOutput: AnyObject {
    func viewDidLoad()
    func addNewTask(title: String, note: String)
    func editTask(id: Int, title: String, note: String, isCompleted: Bool)
    func deleteTask(id: Int)
    func toggleTaskStatus(id: Int)
    func searchTasks(query: String)
}