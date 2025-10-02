//
//  AuthActions.swift
//  Skydivetrack
//
//  Created by Jabba on 10/1/25.
//

import Foundation

// MARK: - Request / Response models

struct LoginRequest {
    let username: String
    let password: String
}

struct LoginResponse: Decodable {
    let token: String?
    let message: String?
    
    // convenience computed property
    var isSuccessful: Bool {
        return token?.isEmpty == false
    }
}

struct SignupRequest {
    let username: String
    let email: String
    let password: String
}

struct SignupResponse: Decodable {
    let token: String?
    let message: String?
    
    var isSuccessful: Bool {
        return token?.isEmpty == false
    }
}

struct RetrievePasswordRequest {
    let email: String
}

struct RetrievePasswordResponse: Decodable {
    // indicate whether the reset email was sent
    let sent: Bool
    let message: String?
}

// MARK: - Mock Actions (replace with real networking)

/// A simple mock pattern that accepts request params and returns a response via completion.
/// Replace implementation with URLSession/your networking stack later.
final class LoginAction {
    let parameters: LoginRequest
    init(parameters: LoginRequest) { self.parameters = parameters }
    
    /// Calls completion on the main queue with a LoginResponse
    func call(_ completion: @escaping (LoginResponse) -> Void) {
        // simulate network latency on background queue
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            // mock success when username == "test" and password == "1234"
            let success = (self.parameters.username == "test" && self.parameters.password == "1234")
            let response = LoginResponse(
                token: success ? "mock_token_123" : nil,
                message: success ? nil : "Invalid username or password"
            )
            DispatchQueue.main.async { completion(response) }
        }
    }
}

final class SignupAction {
    let parameters: SignupRequest
    init(parameters: SignupRequest) { self.parameters = parameters }
    
    func call(_ completion: @escaping (SignupResponse) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.2) {
            // mock: succeed unless username is "taken"
            let success = self.parameters.username.lowercased() != "taken"
            let response = SignupResponse(
                token: success ? "mock_signup_token_456" : nil,
                message: success ? nil : "Username already taken"
            )
            DispatchQueue.main.async { completion(response) }
        }
    }
}

final class RetrievePasswordAction {
    let parameters: RetrievePasswordRequest
    init(parameters: RetrievePasswordRequest) { self.parameters = parameters }
    
    func call(_ completion: @escaping (RetrievePasswordResponse) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            // mock: succeed if email contains "@"
            let sent = self.parameters.email.contains("@")
            let response = RetrievePasswordResponse(
                sent: sent,
                message: sent ? "Reset email sent" : "Invalid email address"
            )
            DispatchQueue.main.async { completion(response) }
        }
    }
}
