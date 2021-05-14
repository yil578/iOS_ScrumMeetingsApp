/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation

// Codable is a type alias that combines the Encodable and Decodable protocols => allow you to use the Codable API to easily serialize data to and from JSON
struct History: Identifiable, Codable {
    // the structure’s properties are all Codable, so don’t have additional work to do
    let id: UUID
    let date: Date
    var attendees: [String]
    var lengthInMinutes: Int

    init(id: UUID = UUID(), date: Date = Date(), attendees: [String], lengthInMinutes: Int) {
        self.id = id
        self.date = date
        self.attendees = attendees
        self.lengthInMinutes = lengthInMinutes
    }
}
