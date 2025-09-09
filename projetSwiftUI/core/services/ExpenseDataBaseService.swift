//
//  AuthService.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import Foundation
import Observation
import FirebaseDatabase
import FirebaseAuth
import UIKit
import FirebaseStorage

@Observable
class ExpenseDataBaseService {
    static let shared = ExpenseDataBaseService()
    
    var expenses: [Expense] = []
    var ranking: [(user: String, totalAmount: Double)] = [] // total des dépenses par user
    var uploaded: UpdateImage?
    
    private let ref = Database.database().reference().child("expenses")
    private let storageRef = Storage.storage().reference()
    let dbRef = Database.database().reference() // public pour accéder aux users
    
    private init() {
        getExpenses()
    }
    
    // MARK: - Ajouter une dépense
    func addExpense(
        name: String,
        amount: Double,
        user: User,
        storeName: String? = nil,
        image: UIImage? = nil,
        description: String? = nil,
        invitedUserIds: [String] = []
    ) {
        let key = ref.childByAutoId().key ?? UUID().uuidString
        let creatorId = user.uid
        
        func saveExpense(imageData: UpdateImage? = nil) {
            let exp = Expense(
                id: key,
                name: name,
                date: Date(),
                amount: amount,
                storeName: storeName,
                invitedUserIds: invitedUserIds,
                imageId: imageData?.id,
                imageDescription: imageData?.description,
                imageUrl: imageData?.url
            )
            
            var dict = exp.toDictionary()
            dict["creatorId"] = creatorId
            ref.child(key).setValue(dict)
        }
        
        if let image = image {
            uploadImage(image: image, description: description ?? "") { result in
                switch result {
                case .success(let imageData):
                    saveExpense(imageData: imageData)
                case .failure(let error):
                    print("Erreur upload image: \(error.localizedDescription)")
                }
            }
        } else {
            saveExpense()
        }
    }
    
    // MARK: - Récupérer toutes les dépenses
    func getExpenses() {
        ref.observe(.value) { snapshot in
            var list: [Expense] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let expense = Expense(snapshot: childSnapshot) {
                    list.append(expense)
                }
            }
            self.expenses = list.sorted { $0.date > $1.date }
            self.updateRanking()
        }
    }
    
    // MARK: - Supprimer une dépense
    func deleteExpense(expense: Expense) {
        ref.child(expense.id).removeValue()
        
        if let imageId = expense.imageId {
            storageRef.child("images/\(imageId).jpg").delete { error in
                if let error = error {
                    print("Erreur suppression image: \(error)")
                } else {
                    print("Image supprimée")
                }
            }
        }
    }
    
    // MARK: - Mettre à jour une dépense
    func updateExpense(expense: Expense, name: String, amount: Double, storeName: String?) {
        var values: [String: Any] = [
            "name": name,
            "amount": amount
        ]
        if let storeName = storeName { values["storeName"] = storeName }
        ref.child(expense.id).updateChildValues(values)
    }
    
    // MARK: - Ajouter un utilisateur invité
    func addUserToExpense(expense: Expense, userId: String, completion: ((Bool) -> Void)? = nil) {
        dbRef.child("users").child(userId).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                print("User \(userId) n'existe pas")
                completion?(false)
                return
            }
            
            if !expense.invitedUserIds.contains(userId) {
                expense.invitedUserIds.append(userId)
                self.ref.child(expense.id).updateChildValues(["invitedUserIds": expense.invitedUserIds])
                self.updateRanking()
                completion?(true)
            } else {
                completion?(false)
            }
        }
    }
    
    // MARK: - Supprimer un utilisateur invité
    func removeUserFromExpense(expense: Expense, userId: String) {
        if let index = expense.invitedUserIds.firstIndex(of: userId) {
            expense.invitedUserIds.remove(at: index)
            ref.child(expense.id).updateChildValues(["invitedUserIds": expense.invitedUserIds])
            updateRanking()
        }
    }
    
    func getAllUsers(completion: @escaping ([(uid: String, displayName: String)]) -> Void) {
        dbRef.child("users").observeSingleEvent(of: .value) { snapshot in
            var list: [(String, String)] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any],
                   let email = dict["email"] as? String {
                    list.append((uid: snap.key, displayName: email))
                }
            }
            completion(list)
        }
    }

    
    // MARK: - Classement
    private func updateRanking() {
        var totals: [String: Double] = [:]
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        
        for expense in expenses {
            let date = Date(timeIntervalSince1970: expense.date)
            let month = calendar.component(.month, from: date)
            let year = calendar.component(.year, from: date)
            
            if month == currentMonth && year == currentYear {
                for userId in expense.invitedUserIds {
                    totals[userId, default: 0] += expense.amount
                }
            }
        }
        self.ranking = totals.sorted { $0.value > $1.value }.map { (user: $0.key, totalAmount: $0.value) }
    }
    
    // MARK: - Upload image
    func uploadImage(image: UIImage, description: String, completion: @escaping (Result<UpdateImage, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "image conversion error", code: 0)))
            return
        }
        
        let idImage = UUID().uuidString
        let imageRef = storageRef.child("images/\(idImage).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            imageRef.downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(NSError(domain: "image url error", code: 0)))
                    return
                }
                
                let uploaded = UpdateImage(
                    id: idImage,
                    url: url.absoluteString,
                    description: description.isEmpty ? "No description" : description
                )
                self.uploaded = uploaded
                completion(.success(uploaded))
            }
        }
    }
    
    // MARK: - Sauvegarder info image
    func saveImageInfo(imageId: String, description: String, url: URL) {
        let data: [String: Any] = [
            "imageId": imageId,
            "description": description,
            "url": url.absoluteString
        ]
        dbRef.child("images").child(imageId).setValue(data)
    }
}

