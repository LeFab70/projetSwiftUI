//
//  ForgetPasswordView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI

struct ForgetPasswordView: View {
    @Environment(\.dismiss) var dismiss
//    @State var password:String="";
//    @State var confirmPassword:String=""
    @State var email:String=""
    @State private var message: String?
    var body: some View {
        NavigationStack {
            Form {
                inputView(inputUser: $email, placeholder: "Email@gmail.coom", imageName: "person.circle")

//                inputView(inputUser: $password, placeholder: "password", imageName: "lock",isSecure: true)
//                inputView(inputUser: $confirmPassword, placeholder: "confirm password", imageName: "lock",isSecure: true)
                if let message = message {
                                    Text(message)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 8)
                                }
                buttonNewPassword
                
            }
            .navigationTitle(Text("Forget password"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement:.topBarTrailing) {
                    Button(action: { dismiss()}) {
                        Label("Cancel", systemImage: "")
                    }
                }
                               
            }
        }
    }
    
    @ViewBuilder
    var buttonNewPassword:some View{
        Button(action: {
                        AuthService.shared.resetPassword(forEmail: email) { success in
                            if success {
                                message = "📩 A reset link has been sent to \(email)"
                            } else {
                                message = AuthService.shared.errorMessage ?? "Error"
                            }
                        }
                    }
        ) {
            HStack {
                            Text("Receive link")
                                .font(.title2.bold())
                            Image(systemName:"lock.rotation")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
               
        } .background(Color.green)
            .disabled(!formValid)
            .opacity(formValid ? 1 : 0.5)
            .cornerRadius(10)
            .padding(.top,24)
            .padding()

    }
}
extension ForgetPasswordView{
    var formValid: Bool {
       return  !email.isEmpty
        && email.contains("@")
    }
}
#Preview {
    ForgetPasswordView()
}
