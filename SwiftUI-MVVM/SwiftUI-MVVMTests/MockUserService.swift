//
//  MockUserService.swift
//  SwiftUI-MVVM
//
//  Created by Anand Yadav on 26/09/24.
//

import XCTest
@testable import SwiftUI_MVVM

class MockUserService: UserServiceProtocol {

    var shouldReturnError = false
    var users: [User] = [User(id: 1, name: "John"), User(id: 2, name: "Anand")]

    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        if shouldReturnError {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error fetching users"])
            completion(.failure(error))
        } else {
            completion(.success(users))
        }
    }
    ///
    var result: Result<[User], Error>?

    func fetchUsers() async -> Result<[User], Error> {
        return result ?? .failure(NSError(domain: "", code: -1, userInfo: nil))
    }
}
