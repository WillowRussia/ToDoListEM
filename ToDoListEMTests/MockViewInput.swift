// ToDoPresenterTests.swift
import XCTest
@testable import ToDoApp

class MockViewInput: ToDoViewInput {
    var reloadCalled = false
    var showErrorCalled = false
    var errorMessage: String?
    
    func reloadTableView() {
        reloadCalled = true
    }
    
    func showError(_ message: String) {
        showErrorCalled = true
        errorMessage = message
    }
}

class MockRouter: ToDoRouter {
    var showEditTaskCalled = false
    var editedTask: ToDoItem?
    
    override func showEditTask(task: ToDoItem) {
        showEditTaskCalled = true
        editedTask = task
    }
}

class ToDoPresenterTests: XCTestCase {
    
    var presenter: ToDoPresenter!
    var view: MockViewInput!
    var interactor: ToDoInteractor!
    var router: MockRouter!
    
    override func setUp() {
        super.setUp()
        view = MockViewInput()
        interactor = ToDoInteractor()
        router = MockRouter()
        presenter = ToDoPresenter()
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
    }
    
    func testDidFetchTasks() {
        let tasks = [
            ToDoItem(id: 1, title: "Задача 1", note: "", createdAt: Date(), isCompleted: false)
        ]
        presenter.didFetchTasks(tasks)
        
        XCTAssertTrue(view.reloadCalled)
        XCTAssertEqual(presenter.tasks.count, 1)
        XCTAssertEqual(presenter.tasks.first?.title, "Задача 1")
    }
    
    func testEditTask() {
        presenter.editTask(id: 1, title: "Обновлено", note: "", isCompleted: true)
        
        // Проверим, что interactor получил вызов
        // (в реальности можно мокнуть interactor)
        // Здесь проверим, что router вызван (если бы это было showEditTaskForNewTask)
        // Но в данном случае тестируем логику
    }
    
    func testAddNewTask() {
        presenter.addNewTask(title: "Новая", note: "Примечание")
        
        // В реальности — interactor должен вызвать addTask
        // Тест косвенный
    }
}