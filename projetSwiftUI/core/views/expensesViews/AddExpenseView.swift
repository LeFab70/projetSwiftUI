//
//  AddExpenseView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    private var expenseService = ExpenseDataBaseService.shared
    
    @State private var name: String = ""
    @State private var amount: Double = 0.0
    @State private var date: Date = Date()
    @State private var storeName: String = ""
    
    // Image
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var imageDescription: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails")) {
                    TextField("Expense Name *", text: $name)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Amount *", value: $amount, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Store Name", text: $storeName)
                }
                
                Section(header: Text("Image associée")) {
                    PhotosPicker(selection: $selectedImageItem, matching: .images) {
                        Label("Choisir une image", systemImage: "photo")
                    }
                    if let image = selectedImage {
                        VStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            TextField("Description de l'image", text: $imageDescription)
                        }
                    }
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if let user = Auth.auth().currentUser {
                            expenseService.addExpense(
                                name: name,
                                amount: amount,
                                user: user,
                                storeName: storeName.isEmpty ? nil : storeName,
                                image: selectedImage,
                                description: selectedImage != nil ? imageDescription : nil,
                                invitedUserIds: []
                            )
                        }
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onChange(of: selectedImageItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
        }
    }
}

// MARK: - Validation du formulaire
extension AddExpenseView {
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        amount > 0 &&
        (selectedImage == nil || !imageDescription.trimmingCharacters(in: .whitespaces).isEmpty)
    }
}

