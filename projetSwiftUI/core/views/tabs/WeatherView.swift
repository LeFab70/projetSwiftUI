//
//  WeatherView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-13.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var weatherService = WeatherService()
    var userLocation: UserLocation
    
    var body: some View {
        VStack {
            // Météo actuelle
            if let current = weatherService.currentWeather {
                HStack(spacing: 16) {
                    if let icon = current.weather.first?.icon {
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 60)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Température actuelle : \(Int(current.main.temp))°C")
                            .font(.title2)
                            .bold()
                        Text(current.weather.first?.description.capitalized ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            } else if let error = weatherService.errorMessage {
                Text("Erreur: \(error)")
                    .foregroundColor(.red)
            } else {
                ProgressView("Chargement de la météo...")
            }
            
            Divider()
                .padding(.vertical, 8)
            
            // Météo quotidienne
            List(weatherService.dailyWeather) { day in
                HStack {
                    Text(Date(timeIntervalSince1970: day.dt), style: .date)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    if let icon = day.weather.first?.icon {
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 40, height: 40)
                    }
                    
                    Text("\(Int(day.main.temp_min))° / \(Int(day.main.temp_max))°")
                        .font(.subheadline)
                    
                    Text(day.weather.first?.main ?? "")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .task {
            guard let lat = userLocation.latitude,
                  let lon = userLocation.longitude else { return }
            await weatherService.fetchWeather(lat: lat, lon: lon)
        }
    }
}

#Preview {
    WeatherView(userLocation: UserLocation(address: "", city: "", province: "QC", postalCode: "H2X1Y4", latitude: 45.514416, longitude: -73.533726))
        .modelContainer(for: UserLocation.self)
}
