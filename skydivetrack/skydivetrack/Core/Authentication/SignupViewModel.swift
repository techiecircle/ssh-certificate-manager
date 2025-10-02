//
//  SignupViewModel.swift
//  Skydivetrack
//
//  Created by Jabba on 10/1/25.
//

import Foundation
import Combine

class SignupViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isSignedUp: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    func signup() {
        guard !isLoading else { return }
        guard password == confirmPassword else {
            self.errorMessage = "Passwords do not match"
            self.showError = true
            return
        }
        
        isLoading = true
        showError = false
        errorMessage = ""
        
        SignupAction(
            parameters: SignupRequest(
                username: username,
                email: email,
                password: password
            )
        ).call { response in
            DispatchQueue.main.async {
                self.isLoading = false
                if let token = response.token, !token.isEmpty {
                    self.isSignedUp = true
                } else {
                    self.errorMessage = response.message ?? "Signup failed"
                    self.showError = true
                }
            }
        }
    }
}

