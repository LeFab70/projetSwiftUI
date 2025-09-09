//
//  Expense.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import Foundation
import FirebaseDatabase

class Expense: Identifiable {
    let id: String
    let name: String
    let date: TimeInterval
    let amount: Double
    var invitedUserIds: [String] // IDs des utilisateurs invités
    let storeName: String? // Nom du commerce ou du magasin
    
    // Champs pour l'image associée
    let imageId: String?
    let imageDescription: String?
    let imageUrl: String?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        date: Date = Date(),
        amount: Double,
        storeName: String? = nil,
        invitedUserIds: [String] = [],
        imageId: String? = nil,
        imageDescription: String? = nil,
        imageUrl: String? = nil
    ) {
        self.id = id
        self.name = name
        self.date = date.timeIntervalSince1970
        self.amount = amount
        self.storeName = storeName
        self.invitedUserIds = invitedUserIds
        self.imageId = imageId
        self.imageDescription = imageDescription
        self.imageUrl = imageUrl
    }
    
    // Initialisation à partir d'un snapshot Firebase
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
              let name = dict["name"] as? String,
              let date = dict["date"] as? TimeInterval,
              let amount = dict["amount"] as? Double else {
            return nil
        }
        
        self.id = dict["id"] as? String ?? snapshot.key
        self.name = name
        self.date = date
        self.amount = amount
        self.storeName = dict["storeName"] as? String
        self.invitedUserIds = dict["invitedUserIds"] as? [String] ?? []
        
        self.imageId = dict["imageId"] as? String
        self.imageDescription = dict["imageDescription"] as? String
        self.imageUrl = dict["imageUrl"] as? String
    }
    
    // Transformer en dictionnaire pour Firebase
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "date": date,
            "amount": amount,
            "invitedUserIds": invitedUserIds
        ]
        
        if let storeName = storeName { dict["storeName"] = storeName }
        if let imageId = imageId { dict["imageId"] = imageId }
        if let imageDescription = imageDescription { dict["imageDescription"] = imageDescription }
        if let imageUrl = imageUrl { dict["imageUrl"] = imageUrl }
        
        return dict
    }
}
