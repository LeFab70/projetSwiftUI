//
//  WeatherService.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-13.
//

import Foundation
import SwiftUI

@MainActor
class WeatherService: ObservableObject {
    @Published var currentWeather: ForecastItem?
    @Published var dailyWeather: [ForecastItem] = []
    @Published var errorMessage: String?
    
    private let apiKey = "e1b25eda638a2631949e04c24c9bf8b1"
    
    func fetchWeather(lat: Double, lon: Double) async {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
            
            // Meteo actuelle = premier élément de la liste
            self.currentWeather = decoded.list.first
            
            // Pour la semaine, on peut grouper par jour et prendre min/max
            let grouped = Dictionary(grouping: decoded.list) { item in
                Calendar.current.startOfDay(for: Date(timeIntervalSince1970: item.dt))
            }
            
            self.dailyWeather = grouped.sorted { $0.key < $1.key }.map { day, items in
                // Pour chaque jour, calcul min/max
                let minTemp = items.map { $0.main.temp_min }.min() ?? 0
                let maxTemp = items.map { $0.main.temp_max }.max() ?? 0
                var representativeItem = items.first!
                representativeItem.main.temp_min = minTemp
                representativeItem.main.temp_max = maxTemp
                return representativeItem
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Modèles JSON Forecast
struct ForecastWeatherDescription: Codable {
    let main: String
    let description: String
    let icon: String
}


struct ForecastItem: Codable, Identifiable {
    let dt: TimeInterval
    var id: TimeInterval { dt }
    var main: ForecastMain
    var weather: [ForecastWeatherDescription]
}


struct ForecastMain: Codable {
    var temp: Double
    var temp_min: Double
    var temp_max: Double
}

struct ForecastResponse: Codable {
    let list: [ForecastItem]
    let city: ForecastCity
}

struct ForecastCity: Codable {
    let id: Int
    let name: String
    let country: String
}

//struct WeatherDescription: Codable {
//    let main: String
//    let description: String
//}
