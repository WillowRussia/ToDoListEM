//
//  ToDoInteractorInput.swift
//  ToDoListEM
//
//  Created by Илья Востров on 02.09.2025.
//


protocol ToDoInteractorInput: AnyObject {
    func loadTasksFromAPI()
    func fetchAllTasks()
    func addTask(title: String, note: String)
    func editTask(id: Int, title: String, note: String, isCompleted: Bool)
    func deleteTask(id: Int)
    func toggleTaskStatus(id: Int)
    func searchTasks(query: String)
}
