import CoreData

class ToDoInteractor {
    weak var presenter: ToDoInteractorOutput?
    
    func loadTasksFromAPI() {
        DispatchQueue.global(qos: .userInitiated).async {
            APIService.shared.fetchToDos { [weak self] result in
                switch result {
                case .success(let networkToDos):
                    let context = CoreDataManager.shared.persistentContainer.newBackgroundContext()
                    context.perform {
                        for networkToDo in networkToDos {
                            let request: NSFetchRequest<NSFetchRequestResult> = CDToDoItem.fetchRequest()
                            request.predicate = NSPredicate(format: "id == %d", networkToDo.id)
                            do {
                                let results = try context.fetch(request)
                                if results.isEmpty {
                                    let item = NSEntityDescription.insertNewObject(forEntityName: "CDToDoItem", into: context) as! CDToDoItem
                                    item.id = Int16(networkToDo.id)
                                    item.title = networkToDo.todo
                                    item.note = ""
                                    item.createdAt = Date()
                                    item.isCompleted = networkToDo.completed
                                }
                            } catch {
                                print("Fetch failed: \(error)")
                            }
                        }
                        try? context.save()
                        self?.fetchAllTasks()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.presenter?.didFailWithError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func fetchAllTasks() {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CoreDataManager.shared.context
            let request: NSFetchRequest<CDToDoItem> = CDToDoItem.fetchRequest()
            do {
                let results = try context.fetch(request)
                let tasks = results.map { cd in
                    ToDoItem(
                        id: Int(cd.id),
                        title: cd.title ?? "",
                        note: cd.note ?? "",
                        createdAt: cd.createdAt ?? Date(),
                        isCompleted: cd.isCompleted
                    )
                }
                DispatchQueue.main.async {
                    self.presenter?.didFetchTasks(tasks)
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailWithError(error.localizedDescription)
                }
            }
        }
    }
    
    func addTask(title: String, note: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CoreDataManager.shared.context
            let item = NSEntityDescription.insertNewObject(forEntityName: "CDToDoItem", into: context) as! CDToDoItem
            item.id = Int16(self.getNextId())
            item.title = title
            item.note = note
            item.createdAt = Date()
            item.isCompleted = false
            do {
                try context.save()
                DispatchQueue.main.async {
                    self.presenter?.didAddTask()
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailWithError(error.localizedDescription)
                }
            }
        }
    }
    
    func editTask(id: Int, title: String, note: String, isCompleted: Bool) {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CoreDataManager.shared.context
            let request: NSFetchRequest<CDToDoItem> = CDToDoItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            do {
                let results = try context.fetch(request)
                if let item = results.first {
                    item.title = title
                    item.note = note
                    item.isCompleted = isCompleted
                    try context.save()
                }
                DispatchQueue.main.async {
                    self.presenter?.didUpdateTask()
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailWithError(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteTask(id: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CoreDataManager.shared.context
            let request: NSFetchRequest<CDToDoItem> = CDToDoItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            do {
                let results = try context.fetch(request)
                if let item = results.first {
                    context.delete(item)
                    try context.save()
                }
                DispatchQueue.main.async {
                    self.presenter?.didDeleteTask()
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailWithError(error.localizedDescription)
                }
            }
        }
    }
    
    func toggleTaskStatus(id: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CoreDataManager.shared.context
            let request: NSFetchRequest<CDToDoItem> = CDToDoItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            do {
                let results = try context.fetch(request)
                if let item = results.first {
                    item.isCompleted.toggle()
                    try context.save()
                }
                DispatchQueue.main.async {
                    self.presenter?.didUpdateTask()
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailWithError(error.localizedDescription)
                }
            }
        }
    }
    
    func searchTasks(query: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CoreDataManager.shared.context
            let request: NSFetchRequest<CDToDoItem> = CDToDoItem.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR note CONTAINS[cd] %@", query, query)
            do {
                let results = try context.fetch(request)
                let tasks = results.map { cd in
                    ToDoItem(
                        id: Int(cd.id),
                        title: cd.title ?? "",
                        note: cd.note ?? "",
                        createdAt: cd.createdAt ?? Date(),
                        isCompleted: cd.isCompleted
                    )
                }
                DispatchQueue.main.async {
                    self.presenter?.didFetchTasks(tasks)
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailWithError(error.localizedDescription)
                }
            }
        }
    }
    
    private func getNextId() -> Int {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<CDToDoItem> = CDToDoItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.fetchLimit = 1
        do {
            let results = try context.fetch(request)
            return results.first.map { Int($0.id) + 1 } ?? 1
        } catch {
            return 1
        }
    }
}