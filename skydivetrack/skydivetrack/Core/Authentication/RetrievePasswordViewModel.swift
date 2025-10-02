//
//  RetrievePasswordViewModel.swift
//  Skydivetrack
//
//  Created by Jabba on 10/1/25.
//
import Foundation
import Combine

class RetrievePasswordViewModel: ObservableObject {
    @Published var email: String = ""
    
    @Published var isSent: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    func sendPasswordReset() {
        guard !isLoading else { return }
        isLoading = true
        showError = false
        errorMessage = ""
        
        let req = RetrievePasswordRequest(email: email)
        RetrievePasswordAction(parameters: req).call { response in
            DispatchQueue.main.async {
                self.isLoading = false
                if response.sent {                       // <-- use `sent` (Bool)
                    self.isSent = true
                } else {
                    self.errorMessage = response.message ?? "Failed to send password reset"
                    self.showError = true
                }
            }
        }
    }
}
