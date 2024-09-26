//
//  UserViewModelTests.swift
//  SwiftUI-MVVM
//
//  Created by Anand Yadav on 26/09/24.
//

import XCTest
@testable import SwiftUI_MVVM

@MainActor
class UserViewModelTests: XCTestCase {
    var viewModel: UserViewModel!
    var mockUserService: MockUserService!
    
    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        viewModel = UserViewModel(userService: mockUserService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserService = nil
        super.tearDown()
    }
    
    func testFetchUsersSuccess() {
        // Arrange
        mockUserService.shouldReturnError = false
        
        // Act
        let expectation = XCTestExpectation(description: "Fetch users successfully")
        
        viewModel.fetchUsers()
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Wait briefly for async completion
            XCTAssertEqual(self.viewModel.users.count, 2, "The users array should contain 2 users")
            XCTAssertEqual(self.viewModel.users[0].name, "John", "First user should be John")
            XCTAssertEqual(self.viewModel.users[1].name, "Anand", "Second user should be Anand")
            XCTAssertFalse(self.viewModel.isLoading, "Loading should be false after fetching users")
            XCTAssertNil(self.viewModel.errorMessage, "Error message should be nil on success")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchUsersFailure() {
        // Arrange
        mockUserService.shouldReturnError = true
        
        // Act
        let expectation = XCTestExpectation(description: "Fetch users failed with error")
        
        viewModel.fetchUsers()
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Wait briefly for async completion
            XCTAssertTrue(self.viewModel.users.isEmpty, "Users array should be empty on failure")
            XCTAssertEqual(self.viewModel.errorMessage, "Error fetching users", "Error message should be set on failure")
            XCTAssertFalse(self.viewModel.isLoading, "Loading should be false after fetching users")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadingState() {
        // Arrange
        mockUserService.shouldReturnError = false
        
        // Act
        let expectation = XCTestExpectation(description: "Check loading state")
        
        viewModel.fetchUsers()
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.isLoading == false, "Loading should stop after fetch")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchUsersSuccess1() async {
        // Given
        let mockUsers = [
            User(id: 1, name: "John Doe"),
            User(id: 2, name: "Jane Smith")
        ]
        mockUserService.result = .success(mockUsers)
        
        // When
        await viewModel.fetchUsers()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.users[0].name, "John Doe")
        XCTAssertEqual(viewModel.users[1].name, "Jane Smith")
    }
    
    func testFetchUsersFailure1() async {
        // Given
        let mockError = NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch users"])
        mockUserService.result = .failure(mockError)
        
        // When
        await viewModel.fetchUsers()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.users.count, 0)
        XCTAssertEqual(viewModel.errorMessage, "Failed to fetch users")
    }
}
