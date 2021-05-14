//
//  DailyScrum.swift
//  Scrumdinger
//
//  Created by Madeline Lee on 5/11/21.
//

import SwiftUI

struct DailyScrum : Identifiable, Codable {
    let id: UUID //requirement to comform to Identifiable protocol
    var title: String
    var attendees: [String]
    var lengthInMinutes: Int
    var color: Color // Color isn’t Codable by default. The Color+Codable extension implements the init(from:) and encode(to:) methods that are necessary to make Color conform to Codable.
    var history: [History]
    
    init(id: UUID = UUID(), title: String, attendees: [String], lengthInMinutes: Int, color: Color, history: [History] = []) {
        self.id = id
        self.title = title
        self.attendees = attendees
        self.lengthInMinutes = lengthInMinutes
        self.color = color
        self.history = history
    }
}

// Just some test data
extension DailyScrum {
    static var data: [DailyScrum] { //note that it's static, so you do DailyScrum.data
        [
            DailyScrum(title: "Design", attendees: ["Cathy", "Daisy", "Simon", "Jonathan"], lengthInMinutes: 10, color: Color("Design")),
            DailyScrum(title: "App Dev", attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"], lengthInMinutes: 5, color: Color("App Dev")),
            DailyScrum(title: "Web Dev", attendees: ["Chella", "Chris", "Christina", "Eden", "Karla", "Lindsey", "Aga", "Chad", "Jenn", "Sarah"], lengthInMinutes: 1, color: Color("Web Dev"))
        ]
    }
}

extension DailyScrum {
    /*
     By making Data a nested type, you keep DailyScrum.Data distinct from the Data structure defined in the Foundation framework.
     
     Data type will contain all the editable properties of DailyScrum.
     */
    struct Data {
        var title: String = ""
        var attendees: [String] = []
        var lengthInMinutes: Double = 5.0
        var color: Color = .random //??
    }
    
    // data property returns Data with the "DailyScrum" property values
    var data: Data { //note that it's not static, so you use a scrum object to do scrum.data
        return Data(title: title, attendees: attendees, lengthInMinutes: Double(lengthInMinutes), color: color) //remember to typecase
    }
    
    mutating func update(from data: Data) {
        title = data.title
        attendees = data.attendees
        lengthInMinutes = Int(data.lengthInMinutes) //remember to typecase
        color = data.color
    }
}
