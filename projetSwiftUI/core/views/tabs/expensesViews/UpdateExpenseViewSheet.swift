import SwiftUI
import FirebaseAuth

struct UpdateExpenseViewSheet: View {
    let expense: Expense
    @State private var name: String
    @State private var amount: Double
    @State private var date: Date
    @State private var storeName: String
    @State private var newUserId: String = "" // uid sélectionné

    // Mapping uid -> displayName/email
    @State private var allUsers: [(uid: String, displayName: String)] = []

    @Environment(\.dismiss) private var dismiss
    private var expenseService = ExpenseDataBaseService.shared
    private var currentUserId = Auth.auth().currentUser?.uid

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
                    if !expense.invitedUserIds.isEmpty {
                        ForEach(expense.invitedUserIds, id: \.self) { userId in
                            if userId != currentUserId {
                                HStack {
                                    Text(allUsers.first(where: { $0.uid == userId })?.displayName ?? userId)
                                    Spacer()
                                    Button(role: .destructive) {
                                        removeUser(userId: userId)
                                    } label: {
                                        Image(systemName: "minus.circle")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    } else {
                        Text("No invited users yet")
                            .foregroundColor(.secondary)
                    }

                    // Picker pour ajouter un utilisateur
                    Picker("Add User", selection: $newUserId) {
                        Text("Select a user").tag("")
                        ForEach(allUsers.filter {
                            !expense.invitedUserIds.contains($0.uid) && $0.uid != currentUserId
                        }, id: \.uid) { user in
                            Text(user.displayName).tag(user.uid)
                        }
                    }

                    Button("Add User") {
                        guard !newUserId.isEmpty else { return }
                        addUser(userId: newUserId)
                       
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newUserId.isEmpty)
                }
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        updateExpense()
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadAllUsers()
            }
        }
    }

    // MARK: - Fonctions
    private func loadAllUsers() {
        expenseService.getAllUsers { users in
            // users: [(uid: String, displayName: String)]
            // On exclut le créateur
            self.allUsers = users.filter { $0.uid != currentUserId }
        }
    }

    private func addUser(userId: String) {
        expenseService.addUserToExpense(expense: expense, userId: userId) { success in
            if success {
                newUserId = ""
            }
        }
    }

    private func removeUser(userId: String) {
        expenseService.removeUserFromExpense(expense: expense, userId: userId)
    }

    private func updateExpense() {
        expenseService.updateExpense(expense: expense, name: name, amount: amount, storeName: storeName)
    }
}
