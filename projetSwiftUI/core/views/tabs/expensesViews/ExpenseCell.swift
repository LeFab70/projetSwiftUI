//
//  ExpenseCell.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI

struct ExpenseCell: View {
    let expense: Expense
    var currentUserId: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            
            // Image associée
            if let urlString = expense.imageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 45, height: 45)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray.opacity(0.5))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Nom de la dépense
                Text(expense.name)
                    .font(.headline)
                    .lineLimit(1)
                
                // Infos secondaires (date, magasin, badge, invités)
                HStack(spacing: 6) {
                    Text(Date(timeIntervalSince1970: expense.date), format: .dateTime.month(.abbreviated).day())
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let store = expense.storeName, !store.isEmpty {
                        Text("· \(store)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Badge Owner / Invité
                    if expense.creatorId == currentUserId {
                        Text("Owner")
                            .font(.caption2)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .clipShape(Capsule())
                    } else if expense.invitedUserIds.contains(currentUserId) {
                        Text("Invité")
                            .font(.caption2)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(Color.orange.opacity(0.2))
                            .foregroundColor(.orange)
                            .clipShape(Capsule())
                    }
                    
                    // Invités 
                    if !expense.invitedUserIds.isEmpty {
                        HStack(spacing: 2) {
                            Image(systemName: "person.2.fill")
                                .font(.caption2)
                                .foregroundColor(.blue)
                            Text("\(expense.invitedUserIds.count)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            Spacer()
            
            // Montant
            Text(expense.amount, format: .currency(code: "CAD"))
                .font(.headline)
                .foregroundColor(.green)
        }
        .padding(.vertical, 6)
    }
}
