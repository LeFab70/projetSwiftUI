//
//  ChangePasswordView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-13.
//

import SwiftUI

struct ChangePasswordView: View {
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var message: String?
    @State private var authService = AuthService.shared
    var body: some View {
        VStack(spacing: 20) {
                   Text("Changer le mot de passe")
                       .font(.title2)
                       .bold()
                   
                   inputView(inputUser: $newPassword,
                             placeholder: "Nouveau mot de passe",
                             imageName: "lock",
                             isSecure: true)
                   
                   inputView(inputUser: $confirmPassword,
                             placeholder: "Confirmer le mot de passe",
                             imageName: "lock.fill",
                             isSecure: true)
                   
                   Button(action: {
                       changePassword()
                   }) {
                       Text("Mettre à jour")
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(Color.green)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                   }
                   .padding(.top, 10)
                   
                   if let message = message {
                       Text(message)
                           .foregroundColor(message.contains("succès") ? .green : .red)
                           .font(.footnote)
                   }
                   
                   //Spacer()
               }
               .padding()
           }
           
           private func changePassword() {
               guard !newPassword.isEmpty, !confirmPassword.isEmpty else {
                   message = "Tous les champs sont requis."
                   return
               }
               
               guard newPassword == confirmPassword else {
                   message = "Les mots de passe ne correspondent pas."
                   return
               }
               
               authService.updatePassword(to: newPassword) { success in
                   if success {
                       message = "Mot de passe mis à jour avec succès ✅"
                       newPassword = ""
                       confirmPassword = ""
                   } else {
                       message = authService.errorMessage ?? "Erreur inconnue"
                   }
               }
    }
}

#Preview {
    ChangePasswordView()
}
