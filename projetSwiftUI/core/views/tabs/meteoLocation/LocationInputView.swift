//
//  LocationInputView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-13.
//

import SwiftUI
import SwiftData
struct LocationInputView: View {
    @Environment(\.modelContext) private var modelContext
        @State private var address = ""
        @State private var city = ""
        @State private var province = ""
        @State private var postalCode = ""
        @State private var message: String?
        
        @Query private var locations: [UserLocation]
    var body: some View {
        ScrollView {
                   VStack(spacing: 16) {
                       Text("Ma localisation")
                           .font(.title2)
                           .bold()
                       
                       inputView(inputUser: $address, placeholder: "Adresse", imageName: "house", isSecure: false)
                       inputView(inputUser: $city, placeholder: "Ville", imageName: "building.2", isSecure: false)
                       inputView(inputUser: $province, placeholder: "Province", imageName: "map", isSecure: false)
                       inputView(inputUser: $postalCode, placeholder: "Code postal", imageName: "mail", isSecure: false)
                       
                       Button("Enregistrer") {
                           saveLocation()
                       }
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.green.opacity(0.8))
                       .foregroundColor(.white)
                       .cornerRadius(10)
                       
                       if let message = message {
                           Text(message)
                               .foregroundColor(message.contains("succès") ? .green : .red)
                               .font(.footnote)
                               .multilineTextAlignment(.center)
                       }
                   }
                   .padding()
               }
               .onAppear {
                   if let first = locations.first {
                       address = first.address
                       city = first.city
                       province = first.province
                       postalCode = first.postalCode
                   }
               }
           }
           
           private func saveLocation() {
               guard !address.isEmpty, !city.isEmpty, !province.isEmpty, !postalCode.isEmpty else {
                   message = "Tous les champs sont requis."
                   return
               }
               
               // Supprimer l'ancienne localisation si elle existe
               if let first = locations.first {
                   modelContext.delete(first)
               }
               
               let newLocation = UserLocation(address: address, city: city, province: province, postalCode: postalCode)
               modelContext.insert(newLocation)
               
               do {
                   try modelContext.save()
                   message = "Localisation enregistrée avec succès ✅"
               } catch {
                   message = "Erreur lors de l'enregistrement: \(error.localizedDescription)"
               }
    }
}

#Preview {
    LocationInputView()
}
