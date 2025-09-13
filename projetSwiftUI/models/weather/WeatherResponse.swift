//
//  WeatherResponse.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-13.
//

import Foundation


struct WeatherResponse: Codable {
    let current: CurrentWeather
    let daily: [DailyWeather]
}

struct CurrentWeather: Codable {
    let temp: Double
    let weather: [WeatherDescription]
}

struct DailyWeather: Codable, Identifiable {
    let dt: TimeInterval
    let temp: Temp
    let weather: [WeatherDescription]
    
    var id: TimeInterval { dt }
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
}

struct WeatherDescription: Codable {
    let main: String
    let description: String
    let icon: String
}
