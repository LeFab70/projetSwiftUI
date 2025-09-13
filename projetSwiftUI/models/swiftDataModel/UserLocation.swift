import SwiftData
import Foundation
import CoreLocation

@Model
class UserLocation {
    @Attribute(.unique) var id: UUID
    var address: String
    var city: String
    var province: String
    var postalCode: String
    var latitude: Double?
    var longitude: Double?
    
    init(address: String = "",
         city: String = "",
         province: String = "",
         postalCode: String = "",
         latitude: Double? = nil,
         longitude: Double? = nil) {
        self.id = UUID()
        self.address = address
        self.city = city
        self.province = province
        self.postalCode = postalCode
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
