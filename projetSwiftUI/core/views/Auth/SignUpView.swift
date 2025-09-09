//
//  SignUpView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI

struct SignUpView: View {
    @State var email:String="";
    @State var password:String="";
    @State var confirmPassword:String=""
    @State private var auth=AuthService.shared
    var body: some View {
        VStack(spacing:15){
            inputView(inputUser: $email, placeholder: "Email@gmail.coom", imageName: "person.circle")
            inputView(inputUser: $password, placeholder: "password", imageName: "lock",isSecure: true)
            inputView(inputUser: $confirmPassword, placeholder: "confirm password", imageName: "lock",isSecure: true)
            buttonSignUp
            if let errorMessage = auth.errorMessage{
                Text(errorMessage).foregroundColor(.red).font(.footnote)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    var buttonSignUp:some View{
        Button(action:
                {auth.errorMessage = nil 
            auth.register(withEmail: email, password:password){
            _ in
        }}
        ) {
            HStack{
              Text("Sign Up")
                    .font(.title2.bold())
                Image(systemName:"person.badge.plus")
                    .resizable()
                    .frame(width: 20, height: 20)
            } .font(.headline)
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
        } .background(Color.green)
            .disabled(!formValid)
            .opacity(formValid ? 1 : 0.5)
            .cornerRadius(10)
            .padding(.top,24)

    }
}
extension SignUpView{
    var formValid: Bool {
       return !email.isEmpty && !password.isEmpty
        && password.count >= 6
        && email.contains("@")
        && !confirmPassword.isEmpty
        && confirmPassword == password
    }
}
#Preview {
    SignUpView()
}
