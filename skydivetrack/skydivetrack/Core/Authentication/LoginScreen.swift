//
//  LoginScreen.swift
//  Skydivetrack
//
//  Created by Jabba on 10/1/25.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject private var viewModel = LoginViewModel()
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case username, password
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    
                    // Logo
                    Image("sd")  // Replace "AppLogo" with your asset name
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.bottom, 40)
                    
                    // Login form
                    VStack {
                        TextField("Login.UsernameField.Title".localized,
                                  text: $viewModel.username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .username)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .password }
                        
                        Divider()
                        
                        SecureField("Login.PasswordField.Title".localized,
                                    text: $viewModel.password)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.go)
                            .onSubmit { viewModel.login() }
                        
                        Divider()
                    }
                    
                    Spacer()
                    
                    // Login Button
                    Button(action: viewModel.login) {
                        Text("Login.LoginButton.Title".localized)
                            .font(.system(size: 24, weight: .bold))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isLoading)
                    
                    // Navigation Links
                    HStack {
                        NavigationLink(destination: SignupScreen()) {
                            Text("Login.SignupLink.Title".localized)
                                .foregroundColor(.green)
                        }
                        Spacer()
                        NavigationLink(destination: RetrievePasswordScreen()) {
                            Text("Login.ForgotPasswordLink.Title".localized)
                                .foregroundColor(.orange)
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(30)
                .blur(radius: viewModel.isLoading ? 3 : 0)
                
                // Loading Spinner
                if viewModel.isLoading {
                    ProgressView("Logging in...".localized)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }
            // Navigate to HomeScreen on success
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                HomeScreen()
            }
            // Error alert
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text("Login Failed".localized),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK".localized))
                )
            }
        }
    }
}

#Preview {
    LoginScreen()
}
