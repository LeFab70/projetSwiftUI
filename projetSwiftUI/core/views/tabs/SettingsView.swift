//
//  SettingsView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-12.
//

import SwiftUI

//struct SettingsView: View {
//    var body: some View {
//        NavigationView {
//            Form {
//                // Section Apparence / Dark Mode
//                Section(header: Text("Apparence").font(.headline),
//                        footer: Text("Activez ou désactivez le mode sombre pour l'application.")) {
//                    DarkModeView()
//                }
//                
//                // Section Sécurité / Changer mot de passe
//                Section(header: Text("Sécurité").font(.headline),
//                        footer: Text("Changez votre mot de passe en toute sécurité.")) {
//                    ChangePasswordView() 
//                }
//                
//                // Section Compte / Supprimer
//                Section(header: Text("Compte").font(.headline),
//                        footer: Text("Supprimer votre compte supprimera toutes vos données.")) {
//                    Button(role: .destructive) {
//                        Task {
//                            do {
//                                try await AuthService.shared.deleteUser()
//                                print("Compte supprimé ✅")
//                            } catch {
//                                print("Erreur suppression compte: \(error.localizedDescription)")
//                            }
//                        }
//                    } label: {
//                        HStack {
//                            Image(systemName: "trash")
//                            Text("Supprimer mon compte")
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Paramètres")
//        }
//    }
//}
import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                
                // Section Apparence / Dark Mode
                VStack(alignment: .leading, spacing: 8) {
                    Text("Apparence")
                        .font(.headline)
                    DarkModeView()
                    Text("Activez ou désactivez le mode sombre pour l'application.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Section Sécurité / Changer mot de passe
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sécurité")
                        .font(.headline)
                    ChangePasswordView()
                    Text("Changez votre mot de passe en toute sécurité.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Section Compte / Supprimer
                VStack(alignment: .leading, spacing: 8) {
                    Text("Compte")
                        .font(.headline)
                    Button(role: .destructive) {
                        Task {
                            do {
                                try await AuthService.shared.deleteUser()
                                print("Compte supprimé ✅")
                            } catch {
                                print("Erreur suppression compte: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Supprimer mon compte")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    Text("Supprimer votre compte supprimera toutes vos données.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    SettingsView()
}
