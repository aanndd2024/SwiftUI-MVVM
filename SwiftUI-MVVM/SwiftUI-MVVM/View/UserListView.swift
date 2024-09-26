//
//  ContentView.swift
//  SwiftUI-MVVM
//
//  Created by Anand Yadav on 26/09/24.
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel = UserViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading users...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else {
                    List(viewModel.users) { user in
                        NavigationLink(destination: UserDetailView(user: user)) {
                            Text(user.name)
                        }
                    }
                }
            }
            .navigationTitle("Users")
//            .onAppear {
//                viewModel.fetchUsers()
//            }
            .task {
                await viewModel.fetchUsers()
            }
        }
    }
}

struct UserDetailView: View {
    let user: User
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Name: \(user.name)")
            Text("Id: \(user.id)")
            Spacer()
        }
        .padding()
        .navigationTitle(user.name)
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(user: User(id: 11, name: "Anand"))
    }
}

#Preview {
    UserListView()
}
