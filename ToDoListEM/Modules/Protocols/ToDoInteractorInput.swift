// Протокол
protocol ToDoInteractorInput: AnyObject {
    func loadTasksFromAPI()
    func fetchAllTasks()
    func addTask(title: String, note: String)
    func editTask(id: Int, title: String, note: String, isCompleted: Bool)
    func deleteTask(id: Int)
    func toggleTaskStatus(id: Int)
    func searchTasks(query: String)
}