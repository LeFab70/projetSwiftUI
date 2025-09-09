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
        HStack {
            Text(Date(timeIntervalSince1970: expense.date), format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(expense.name)
            Spacer()
            Text(expense.amount, format: .currency(code: "CAD"))
                .foregroundColor(.secondary)
        }
    }
}
