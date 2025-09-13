//
//  MapViewFromUserLocation.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-13.
//
import SwiftUI
import MapKit
import CoreLocation
import SwiftData

struct MapViewFromUserLocation: View {
    @Environment(\.modelContext) private var modelContext
        @Query private var locations: [UserLocation]

        @State private var cameraPosition: MapCameraPosition = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 45.514416, longitude: -73.533726),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        )

        @State private var userCoordinate: CLLocationCoordinate2D?
        @State private var isLoading = false
        @State private var errorMessage: String?

        var body: some View {
            NavigationView {
                VStack {
                    if let coordinate = userCoordinate {
                        Map(position: $cameraPosition) {
                            Annotation("Votre position", coordinate: coordinate) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                            }
                        }
                        .frame(height: 200)
                    } else if isLoading {
                        ProgressView("Chargement de la position...")
                            .frame(height: 200)
                    } else {
                        Text("Aucune localisation disponible")
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    }
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    Spacer()
                }
                .navigationTitle("Ma position")
                .onAppear {
                    loadUserLocation()
                    //print("MapViewFromUserLocation.onAppear")
                }
            }
        }
    
    private func loadUserLocation() {
        guard let location = locations.first else { return }
        
        if let coordinate = location.coordinate {
            // Utiliser les coordonnées déjà stockées
            userCoordinate = coordinate
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            )
        } else {
            // Géocoder seulement si coords manquent
            let fullAddress = "\(location.address), \(location.city), \(location.province), \(location.postalCode)"
            let geocoder = CLGeocoder()
            isLoading = true
            geocoder.geocodeAddressString(fullAddress) { placemarks, error in
                isLoading = false
                if let error = error {
                    errorMessage = "Impossible de localiser l'adresse : \(error.localizedDescription)"
                    return
                }
                if let coordinate = placemarks?.first?.location?.coordinate {
                    userCoordinate = coordinate
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    )
                } else {
                    errorMessage = "Coordonnées introuvables"
                }
            }
        }
    }

    }

#Preview {
    MapViewFromUserLocation()
}
