//
//  SignupScreen.swift
//  Skydivetrack
//
//  Created by Jabba on 10/1/25.
//

import SwiftUI

struct SignupScreen: View {
    @StateObject private var viewModel = SignupViewModel()
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case username, email, password, confirmPassword
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    
                    VStack {
                        TextField("Signup.UsernameField.Title".localized,
                                  text: $viewModel.username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .username)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .email }
                        
                        Divider()
                        
                        TextField("Signup.EmailField.Title".localized,
                                  text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .password }
                        
                        Divider()
                        
                        SecureField("Signup.PasswordField.Title".localized,
                                    text: $viewModel.password)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .confirmPassword }
                        
                        Divider()
                        
                        SecureField("Signup.ConfirmPasswordField.Title".localized,
                                    text: $viewModel.confirmPassword)
                            .focused($focusedField, equals: .confirmPassword)
                            .submitLabel(.go)
                            .onSubmit { viewModel.signup() }
                        
                        Divider()
                    }
                    
                    Spacer()
                    
                    Button(action: viewModel.signup) {
                        Text("Signup.SignupButton.Title".localized)
                            .font(.system(size: 24, weight: .bold))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding(30)
                .blur(radius: viewModel.isLoading ? 3 : 0)
                
                if viewModel.isLoading {
                    ProgressView("Signing up...".localized)
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }
            .navigationDestination(isPresented: $viewModel.isSignedUp) {
                HomeScreen()
            }
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text("Signup Failed".localized),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK".localized))
                )
            }
        }
    }
}

#Preview {
    SignupScreen()
}
