//
//  ToDoViewOutput.swift
//  ToDoListEM
//
//  Created by Илья Востров on 28.08.2025.
//


import Foundation

protocol ToDoViewOutput: AnyObject {
    func viewDidLoad()
    
    func addNewTask(title: String, note: String)
    func editTask(id: Int, title: String, note: String, isCompleted: Bool)
    func deleteTask(id: Int)
    func toggleTaskStatus(id: Int)
    func searchTasks(query: String)
    
    var router: ToDoRouter? { get }
    var tasks: [ToDoItem] { get }
}
