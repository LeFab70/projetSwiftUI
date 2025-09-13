//
//  ExpenseCell.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI

struct ExpenseCell: View {
    let expense: Expense
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            // Image associée
            if let urlString = expense.imageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 50))
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
                
                // Date et magasin
                HStack {
                    Text(Date(timeIntervalSince1970: expense.date), format: .dateTime.month(.abbreviated).day())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let store = expense.storeName, !store.isEmpty {
                        Text("· \(store)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Invités
                if !expense.invitedUserIds.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("\(expense.invitedUserIds.count) invité(s)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            // Montant
            Text(expense.amount, format: .currency(code: "CAD"))
                .font(.headline)
                .foregroundColor(.green)
        }
        .padding(.vertical, 8)
    }
}
