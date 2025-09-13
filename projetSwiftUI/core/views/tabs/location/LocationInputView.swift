//
//  LocationInputView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-13.
//

import SwiftUI
import SwiftData
import CoreLocation

struct LocationInputView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var address = ""
    @State private var postalCode = ""
    @State private var selectedProvince = "QC"
    @State private var message: String?
    
    @Query private var locations: [UserLocation]
    
    private let provinces = ["AB","BC","MB","NB","NL","NS","ON","PE","QC","SK","NT","NU","YT"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Ma localisation")
                    .font(.title2)
                    .bold()
                
                inputView(inputUser: $address, placeholder: "Adresse (optionnel)", imageName: "house", isSecure: false)
                inputView(inputUser: $postalCode, placeholder: "Code postal", imageName: "mail", isSecure: false)
                
                Picker("Province", selection: $selectedProvince) {
                    ForEach(provinces, id: \.self) { province in
                        Text(province)
                    }
                }
                .pickerStyle(.menu)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .frame(maxWidth: .infinity)
                
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
                        .padding(.top, 4)
                }
            }
            .padding()
        }
        .onAppear {
            if let first = locations.first {
                address = first.address
                postalCode = first.postalCode
                selectedProvince = first.province
            }
        }
    }
    private func saveLocation() {
        guard !postalCode.isEmpty else {
            message = "Le code postal est requis."
            return
        }
        
        let fullAddress = "\(address), \(postalCode), \(selectedProvince), Canada"
        let geocoder = CLGeocoder()
        message = "Géolocalisation en cours..."
        
        geocoder.geocodeAddressString(fullAddress) { placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    message = "Impossible de localiser l'adresse : \(error.localizedDescription)"
                    return
                }
                
                guard let placemark = placemarks?.first,
                      let coordinate = placemark.location?.coordinate else {
                    message = "Coordonnées introuvables pour cette adresse."
                    return
                }
                
                // Supprimer ancienne localisation
//                if let first = locations.first {
//                    modelContext.delete(first)
//                }
                
                let oldLocations = locations
                oldLocations.forEach { modelContext.delete($0) }

                
                let newLocation = UserLocation(
                    address: address,
                    city: placemark.locality ?? "city",
                    province: selectedProvince,
                    postalCode: postalCode,
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
                modelContext.insert(newLocation)
                
                do {
                    try modelContext.save()
                    message = "Localisation enregistrée ✅"
                } catch {
                    message = "Erreur lors de l'enregistrement: \(error.localizedDescription)"
                }
            }
        }
    }

}

#Preview {
    LocationInputView()
        .modelContainer(for: UserLocation.self)
}
