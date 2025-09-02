//
//  APIService.swift
//  ToDoListEM
//
//  Created by Илья Востров on 28.08.2025.
//
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
                let response = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(response.todos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
