//
//  ToDoInteractorOutput.swift
//  ToDoListEM
//
//  Created by Илья Востров on 28.08.2025.
//


protocol ToDoInteractorOutput: AnyObject {
    func didFetchTasks(_ tasks: [ToDoItem])
    func didAddTask()
    func didUpdateTask()
    func didDeleteTask()
    func didFailWithError(_ error: String)
}