//
//  UserViewModel.swift
//  SwiftUI-MVVM
//
//  Created by Anand Yadav on 26/09/24.
//

import Combine
import Foundation

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func fetchUsers() {
        isLoading = true
        errorMessage = nil
        
        userService.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let users):
                    self?.users = users
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchUsers() async {
        isLoading = true
        errorMessage = nil
        
        let result = await userService.fetchUsers()
        
        switch result {
        case .success(let users):
            self.users = users
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
