import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchToDos(completion: @escaping (Result<[NetworkToDo], Error>) -> Void) {
        let url = URL(string: "https://dummyjson.com/todos")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            
            do {
                let result = try JSONDecoder().decode([String: [NetworkToDo]].self, from: data)
                if let todos = result["todos"] {
                    completion(.success(todos))
                } else {
                    completion(.failure(NSError(domain: "Invalid format", code: 0)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}