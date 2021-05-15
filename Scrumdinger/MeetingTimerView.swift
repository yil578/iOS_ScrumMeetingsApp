//
//  MeetingTimerView.swift
//  Scrumdinger
//
//  Created by Madeline Lee on 5/14/21.
//

import SwiftUI

// conforms to the Shape protocol. The Shape protocol has one required function: path(in:)
struct SpeakerArc: Shape {
    let speakerIndex: Int
    let totalSpeakers: Int
    
    private var degreesPerSpeaker: Double {
        360.0 / Double(totalSpeakers)
    }
    
    private var startAngle: Angle {
        Angle(degrees: degreesPerSpeaker * Double(speakerIndex) + 1.0) // The additional 1.0 degree is for visual separation between arc segments
    }
    
    private var endAngle: Angle {
        Angle(degrees: startAngle.degrees + degreesPerSpeaker - 1.0)
    }
    
    // The path(in:) function takes a CGRect parameter. The coordinate system contains an origin in the lower left corner, with positive values extending up and to the right.
    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        let radius = diameter / 2.0
        let center = CGPoint(x: rect.origin.x + rect.size.width / 2.0,
                             y: rect.origin.y + rect.size.height / 2.0)
        return Path { path in // the Path initializer takes a closure that passes in a path parameter
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
    }
}

struct MeetingTimerView: View {
    let speakers: [ScrumTimer.Speaker]
    var scrumColor: Color
    
    //computed property that returns name of currentSpeaker (the first speaker not completed)
    private var currentSpeaker: String { speakers.first(where: { !$0.isCompleted })?.name ?? "Someone" }
    
    var body: some View {
        // Putting Text and Circle in a ZStack makes the text appear inside the circle.
        ZStack {
            Circle()
                .strokeBorder(lineWidth: 24, antialiased: true)
            VStack {
                Text(currentSpeaker)
                    .font(.title)
                Text("is speaking")
            }
            .accessibilityElement(children: .combine) //combine the elements inside the VStack for accessibility (makes VoiceOver read the two Text views as one sentence)
            .foregroundColor(scrumColor.accessibleFontColor)
            ForEach(speakers) { speaker in
                if speaker.isCompleted, //COOL! (here is if-let statement, in other files, you use lots of guard-let
                   let index = speakers.firstIndex(where: { $0.id == speaker.id }) {
                    SpeakerArc(speakerIndex: index, totalSpeakers: speakers.count)
                        .rotation(Angle(degrees: -90)) //rotate counterclockwise 90
                        .stroke(scrumColor, lineWidth: 12)
                }
            }
        }
    }
}

struct MeetingTimerView_Preview: PreviewProvider {
    static var speakers = [ScrumTimer.Speaker(name: "Kim", isCompleted: true), ScrumTimer.Speaker(name: "Bill", isCompleted: false)]
    static var previews: some View {
        MeetingTimerView(speakers: speakers, scrumColor: Color("Design"))
    }
}
