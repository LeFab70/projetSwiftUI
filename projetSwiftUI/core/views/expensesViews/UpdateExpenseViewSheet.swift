//
//  UpdateExpenseViewSheet.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI

struct UpdateExpenseViewSheet: View {
    let expense: Expense
    @State private var name: String
    @State private var amount: Double
    @State private var date: Date
    @State private var storeName: String=""
    @State private var newUserId: String = "" // pour ajouter un invité
    
    @Environment(\.dismiss) private var dismiss
    private var expenseService = ExpenseDataBaseService.shared
    
    init(expense: Expense) {
        self.expense = expense
        _name = State(initialValue: expense.name)
        _amount = State(initialValue: expense.amount)
        _date = State(initialValue: Date(timeIntervalSince1970: expense.date))
        _storeName = State(initialValue: expense.storeName ?? "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Expense Info") {
                    TextField("Expense Name", text: $name)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Amount", value: $amount, format: .currency(code: "CAD"))
                        .keyboardType(.decimalPad)
                    TextField("Store Name", text: $storeName)
                }
                
                Section("Invited Users") {
                    // Afficher les invités existants
                    if !expense.invitedUserIds.isEmpty {
                        ForEach(expense.invitedUserIds, id: \.self) { userId in
                            Text(userId)
                        }
                    } else {
                        Text("No invited users yet")
                            .foregroundColor(.secondary)
                    }
                    
                    // Ajouter un nouvel invité
                    HStack {
                        TextField("User ID", text: $newUserId)
                        Button("Add") {
                            guard !newUserId.isEmpty else { return }
                            expenseService.addUserToExpense(expense: expense, userId: newUserId)
                            newUserId = ""
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        // Mise à jour principale de la dépense
                        expenseService.updateExpense(
                            expense: expense,
                            name: name,
                            amount: amount,
                            storeName: storeName
                        )
                        dismiss()
                    }
                }
            }
        }
    }
}
