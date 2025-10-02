import SwiftUI

struct AuthView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @EnvironmentObject var api: APIService

    var body: some View {
        VStack(spacing: 20) {
            Text("Skydive-Track Login")
                .font(.title)
                .padding()

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Login") {
                api.login(username: username, password: password) { success in
                    if !success {
                        errorMessage = "Invalid credentials"
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Text("Use: test / 1234")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}
