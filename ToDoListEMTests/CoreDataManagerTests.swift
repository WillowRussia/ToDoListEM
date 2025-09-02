// CoreDataManagerTests.swift
import XCTest
@testable import ToDoApp

class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
        
        // Используем in-memory store
        let container = NSPersistentContainer(name: "ToDoModel")
        let description = container.persistentStoreDescriptions.first
        description?.url = URL(fileURLWithPath: "/dev/null") // In-memory
        container.loadPersistentStores { _, error in
            if let error = error {
                XCTFail("Failed to load in-memory store: \(error)")
            }
        }
        
        context = container.viewContext
    }
    
    func testSaveAndFetchTask() {
        // Создаём задачу
        let entity = NSEntityDescription.insertNewObject(forEntityName: "CDToDoItem", into: context) as! CDToDoItem
        entity.id = 1
        entity.title = "Тестовая задача"
        entity.note = "Описание"
        entity.createdAt = Date()
        entity.isCompleted = false
        
        // Сохраняем
        do {
            try context.save()
        } catch {
            XCTFail("Не удалось сохранить: \(error)")
        }
        
        // Читаем
        let fetchRequest: NSFetchRequest<CDToDoItem> = CDToDoItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", 1)
        
        do {
            let results = try context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1)
            XCTAssertEqual(results.first?.title, "Тестовая задача")
            XCTAssertEqual(results.first?.isCompleted, false)
        } catch {
            XCTFail("Ошибка при чтении: \(error)")
        }
    }
}