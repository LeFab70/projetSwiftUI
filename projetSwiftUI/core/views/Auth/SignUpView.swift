//
//  SignUpView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var displayName: String = ""
    
    @State private var auth = AuthService.shared
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 15) {
            
            inputView(inputUser: $displayName, placeholder: "Display Name", imageName: "person")
            inputView(inputUser: $email, placeholder: "Email@gmail.com", imageName: "envelope")
            inputView(inputUser: $password, placeholder: "Password", imageName: "lock", isSecure: true)
            inputView(inputUser: $confirmPassword, placeholder: "Confirm Password", imageName: "lock", isSecure: true)
            
            buttonSignUp
            
            if let errorMessage = auth.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    var buttonSignUp: some View {
        Button(action: {
            auth.errorMessage = nil
            isLoading = true
            auth.register(withEmail: email, password: password, displayName: displayName) { success in
                isLoading = false
                if success {
                    print("User registered successfully")
                }
            }
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(width: 20, height: 20)
                } else {
                    Text("Sign Up")
                        .font(.title2.bold())
                    Image(systemName: "person.badge.plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(formValid ? Color.green : Color.gray)
            .cornerRadius(10)
            .opacity(formValid ? 1 : 0.6)
            .padding(.top, 24)
        }
        .disabled(!formValid || isLoading)
    }
}

extension SignUpView {
    var formValid: Bool {
        !displayName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.isEmpty &&
        email.contains("@") &&
        !password.isEmpty &&
        password.count >= 6 &&
        !confirmPassword.isEmpty &&
        confirmPassword == password
    }
}
