//
//  UserLocation.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-13.
//

import SwiftData
import Foundation

@Model
class UserLocation {
    @Attribute(.unique) var id: UUID
    var address: String
    var city: String
    var province: String
    var postalCode: String
    
    init(address: String = "", city: String = "", province: String = "", postalCode: String = "") {
        self.id = UUID()
        self.address = address
        self.city = city
        self.province = province
        self.postalCode = postalCode
    }
}

