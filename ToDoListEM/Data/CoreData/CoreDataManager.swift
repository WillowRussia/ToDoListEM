//
//  CoreDataManager.swift
//  ToDoListEM
//
//  Created by Илья Востров on 28.08.2025.
//


import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoListModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка загрузги данных из CoreData: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            context.perform {
                do {
                    try self.context.save()
                } catch {
                    print("Ошибка сохранения: \(error)")
                }
            }
        }
    }
}
