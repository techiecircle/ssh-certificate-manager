//
//  LoginViewModel.swift
//  Skydivetrack
//
//  Created by Jabba on 10/1/25.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    func login() {
        guard !isLoading else { return }
        isLoading = true
        showError = false
        errorMessage = ""
        
        LoginAction(
            parameters: LoginRequest(
                username: username,
                password: password
            )
        ).call { response in
            DispatchQueue.main.async {
                self.isLoading = false
                if let token = response.token, !token.isEmpty {
                    // login successful
                    self.isLoggedIn = true
                } else {
                    self.errorMessage = response.message ?? "Login failed"
                    self.showError = true
                }
            }
        }
    }
}
