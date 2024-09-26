//
//  UserService.swift
//  SwiftUI-MVVM
//
//  Created by Anand Yadav on 26/09/24.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void)
    func fetchUsers() async -> Result<[User], Error>
}

class UserService: UserServiceProtocol {
    private let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchUsers() async -> Result<[User], Error> {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let users = try JSONDecoder().decode([User].self, from: data)
            
            return .success(users)
        } catch {
            return .failure(error)
        }
    }
}
