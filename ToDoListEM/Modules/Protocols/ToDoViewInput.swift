protocol ToDoViewInput: AnyObject {
    func reloadTableView()
    func showError(_ message: String)
}