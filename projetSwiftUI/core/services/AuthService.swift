//
//  AuthService.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import Foundation
import Observation
import FirebaseAuth
import FirebaseDatabase

@Observable
class AuthService {
    static let shared = AuthService()
    
    var user: User? // vient de FirebaseAuth
    var errorMessage: String?
    
    private let dbRef = Database.database().reference()
    
    /// Register new user
    func register(withEmail email: String, password: String, displayName: String? = nil, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(false)
                return
            }
            
            self.user = firebaseUser
            self.errorMessage = nil
            
            // Sauvegarde dans Realtime DB
            let userData: [String: Any] = [
                "uid": firebaseUser.uid,
                "email": firebaseUser.email ?? "",
                "displayName": displayName ?? firebaseUser.email?.components(separatedBy: "@").first ?? "Unknown",
                "createdAt": Date().timeIntervalSince1970
            ]
            
            self.dbRef.child("users").child(firebaseUser.uid).setValue(userData) { error, _ in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    /// Login existing user
    func login(withEmail email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            
            self.user = result?.user
            self.errorMessage = nil
            
            completion(true)
        }
    }
    
    /// Logout
    func logout() async throws {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    /// Delete user
    func deleteUser() async throws {
        do {
            try await Auth.auth().currentUser?.delete()
            if let uid = self.user?.uid {
                try await dbRef.child("users").child(uid).removeValue()
            }
            self.user = nil
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    /// Reset password
    func resetPassword(forEmail email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.errorMessage = nil
            completion(true)
        }
    }
    
    /// Update password
    func updatePassword(to newPassword: String, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            self.errorMessage = "Aucun utilisateur connecté"
            completion(false)
            return
        }
        
        user.updatePassword(to: newPassword) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
            } else {
                self.errorMessage = nil
                completion(true)
            }
        }
    }
}
