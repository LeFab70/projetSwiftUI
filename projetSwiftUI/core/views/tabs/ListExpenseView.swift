//
//  ListExpenseView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI

struct ListExpenseView: View {
    @State var expenseService = ExpenseDataBaseService.shared
    @State var showAddExpense: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(expenseService.expenses) { expense in
                        NavigationLink(destination: UpdateExpenseViewSheet(expense: expense)) {
                            ExpenseCell(expense: expense)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let expense = expenseService.expenses[index]
                            expenseService.deleteExpense(expense: expense)
                        }
                    }
                    
                    if !expenseService.expenses.isEmpty {
                        Button("Delete All") {
                            for expense in expenseService.expenses {
                                expenseService.deleteExpense(expense: expense)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .navigationTitle("Expenses")
                .navigationBarTitleDisplayMode(.large)
                .sheet(isPresented: $showAddExpense) {
                    AddExpenseSheet()
                }
                .toolbar {
                    Button("Add Expense", systemImage: "plus.circle.fill") {
                        showAddExpense = true
                    }
                }
                .overlay {
                    if expenseService.expenses.isEmpty {
                        ContentUnavailableView(
                            label: { Label("No Expenses yet", systemImage: "list.bullet.rectangle.portrait") },
                            description: { Text("Add your first expense.") },
                            actions: {
                                Button("Add Expense", systemImage: "plus.circle.fill") {
                                    showAddExpense = true
                                }
                            }
                        )
                        .offset(y: -50)
                    }
                }
            }
            .background(Color.blue.opacity(0.05))
        }
    }
}
