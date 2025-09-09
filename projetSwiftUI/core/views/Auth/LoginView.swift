//
//  LoginView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State private var showForgetPassword: Bool = false
    @State private var auth = AuthService.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                inputView(inputUser: $email,
                          placeholder: "Email@gmail.com",
                          imageName: "person.circle")
                
                inputView(inputUser: $password,
                          placeholder: "password",
                          imageName: "lock",
                          isSecure: true)
                
                buttonSignIn
                
                if let errorMessage = auth.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                Spacer()
                forgetPassword
            }
            .padding()
            .navigationDestination(isPresented: $showForgetPassword) {
                ForgetPasswordView()
            }
          
        }
      
    }
    
    var forgetPassword: some View {
        Button(action: { showForgetPassword.toggle() }) {
            Label("Forget password?", systemImage: "key.fill")
        }
        .buttonStyle(.borderless)
        .foregroundStyle(.red.opacity(0.7))
        .font(.subheadline.bold())
    }
    
    var buttonSignIn: some View {
        Button(action: {
            auth.login(withEmail: email, password: password) { _ in }
        }) {
            HStack {
                Text("Sign In")
                    .font(.title2.bold())
                Image(systemName: "arrow.right.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 50)
        }
        .background(Color.green)
        .disabled(!formValid)
        .opacity(formValid ? 1 : 0.5)
        .cornerRadius(10)
        .padding(.top, 24)
    }
}

extension LoginView {
    var formValid: Bool {
        !email.isEmpty && !password.isEmpty &&
        password.count >= 6 && email.contains("@")
    }
}

#Preview {
    LoginView()
}
