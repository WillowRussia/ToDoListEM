// APIServiceTests.swift
import XCTest
@testable import ToDoApp

class APIServiceTests: XCTestCase {
    
    var apiService: APIService!
    
    override func setUp() {
        super.setUp()
        apiService = APIService.shared
    }
    
    func testFetchToDos_Success() {
        let expectation = self.expectation(description: "Fetch todos")
        
        apiService.fetchToDos { result in
            switch result {
            case .success(let todos):
                XCTAssertFalse(todos.isEmpty, "Задачи не должны быть пустыми")
                XCTAssertGreaterThan(todos.count, 0)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Ошибка: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testFetchToDos_ValidData() {
        let expectation = self.expectation(description: "Valid data structure")
        
        apiService.fetchToDos { result in
            switch result {
            case .success(let todos):
                let first = todos.first
                XCTAssertNotNil(first?.id)
                XCTAssertNotNil(first?.todo)
                XCTAssertNotNil(first?.completed)
                XCTAssertNotNil(first?.userId)
                expectation.fulfill()
            case .failure:
                XCTFail("Должен быть успех")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
}