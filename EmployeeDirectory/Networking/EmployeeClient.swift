//
//  EmployeeClient.swift
//  EmployeeDirectory
//
//  Created by Naveen George Thoppan on 01/05/2022.
//

import Foundation

protocol EmployeeService {
    func getEmployees(completion:
                      @escaping (Employees?, Error?) -> Void) -> URLSessionDataTask
}

class EmployeeClient: EmployeeService {
    
    let baseUrl: URL
    let session: URLSession
    let responseQueue: DispatchQueue?
    
    static let shared = EmployeeClient(
        baseUrl: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/")!,
        session: .shared,
        responseQueue: .main
    )
    
    init(
        baseUrl: URL,
        session: URLSession,
        responseQueue: DispatchQueue?) {
            self.baseUrl = baseUrl
            self.session = session
            self.responseQueue = responseQueue
        }
    
    func getEmployees(completion: @escaping (Employees?, Error?) -> Void) -> URLSessionDataTask {
        let url = URL(string: "employees.json", relativeTo: baseUrl)!
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                error == nil,
                let data = data
            else {
                self.dispatchResult(error: error, completion: completion)
                return
            }
            
            do {
                let employees = try JSONDecoder().decode(Employees.self, from: data)
                self.dispatchResult(models: employees, error: error, completion: completion)
            } catch {
                self.dispatchResult(error: error, completion: completion)
            }
        }
        task.resume()
        return task
    }
    
    private func dispatchResult<Type>(
        models: Type? = nil,
        error: Error? = nil,
        completion: @escaping (Type?, Error?) -> Void
    ) {
        guard let responseQueue = responseQueue else {
            completion(models, error)
            return
        }
        responseQueue.async {
            completion(models, error)
        }
    }
}
