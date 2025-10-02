//
//  RetrievePasswordScreen.swift
//  Skydivetrack
//
//  Created by Jabba on 10/1/25.
//

import SwiftUI

struct RetrievePasswordScreen: View {
    @StateObject private var viewModel = RetrievePasswordViewModel()
    @FocusState private var emailFieldFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    
                    TextField("RetrievePassword.EmailField.Title".localized,
                              text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .focused($emailFieldFocused)
                        .submitLabel(.go)
                        .onSubmit { viewModel.sendPasswordReset() }
                    
                    Divider()
                        .padding(.bottom, 30)
                    
                    Button(action: viewModel.sendPasswordReset) {
                        Text("RetrievePassword.SendButton.Title".localized)
                            .font(.system(size: 24, weight: .bold))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .foregroundColor(.white)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isLoading)
                    
                    Spacer()
                }
                .padding(30)
                .blur(radius: viewModel.isLoading ? 3 : 0)
                
                if viewModel.isLoading {
                    ProgressView("Sending...".localized)
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }
            // Error alert
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text("Error".localized),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK".localized))
                )
            }
            // Success alert
            .alert("Success".localized, isPresented: $viewModel.isSent, actions: {
                Button("OK".localized, role: .cancel) { }
            }, message: {
                Text("Password reset email sent".localized)
            })
        }
    }
}
