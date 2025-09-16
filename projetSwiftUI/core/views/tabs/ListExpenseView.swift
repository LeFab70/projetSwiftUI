//
//  ListExpenseView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI
import FirebaseAuth

struct ListExpenseView: View {
    @State var expenseService = ExpenseDataBaseService.shared
    @State var showAddExpense: Bool = false
    
    @State private var currentPage: Int = 0
    private let pageSize: Int = 4
    
    // ID de l’utilisateur connecté
    var currentUserId: String = Auth.auth().currentUser?.uid ?? ""
    
    // Pagination
    private var paginatedExpenses: [Expense] {
        let start = currentPage * pageSize
        let end = min(start + pageSize, expenseService.expenses.count)
        if start < end {
            return Array(expenseService.expenses[start..<end])
        }
        return []
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !expenseService.expenses.isEmpty {
                    Button {
                        showAddExpense = true
                    } label: {
                        Label("Add Expense", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .padding(.vertical, 6)
                    }
                }
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(paginatedExpenses) { expense in
                            if expense.creatorId == currentUserId {
                                NavigationLink(destination: UpdateExpenseViewSheet(expense: expense)) {
                                    ExpenseCell(expense: expense, currentUserId: currentUserId)
                                }
                            } else if expense.invitedUserIds.contains(currentUserId) {
                                ExpenseCell(expense: expense, currentUserId: currentUserId)
                                    .opacity(0.9)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Pagination controls
                HStack {
                    Button("← Précédent") {
                        if currentPage > 0 { currentPage -= 1 }
                    }
                    .disabled(currentPage == 0)
                    
                    Spacer()
                    
                    Button("Suivant →") {
                        if (currentPage + 1) * pageSize < expenseService.expenses.count {
                            currentPage += 1
                        }
                    }
                    .disabled((currentPage + 1) * pageSize >= expenseService.expenses.count)
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAddExpense) {
                AddExpenseView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddExpense = true
                    } label: {
                        Label("Add Expense", systemImage: "plus.circle.fill")
                    }
                }
            }
        }
    }
}
