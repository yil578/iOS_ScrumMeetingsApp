//
//  MeetingView.swift
//  Scrumdinger
//
//  Created by Madeline Lee on 5/10/21.
//

import SwiftUI

struct MeetingView: View {
    @Binding var scrum: DailyScrum // Create a scrum binding
    @StateObject var scrumTimer = ScrumTimer() // Wrapping a property as a @StateObject means the view owns the source of truth for the "object" ("reference type" model). @StateObject ties the ScrumTimer ObservableObject to the MeetingView life cycle.
    // requirement to conform to View protocol: body property that returns a View
    var body: some View {
        // use a ZStack to draw a simple shape behind the meeting view
        ZStack {
            // Because a ZStack overlays views back to front, the RoundedRectangle appears behind the VStack
            RoundedRectangle(cornerRadius: 16.0)
                .fill(scrum.color)
            VStack {
                MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, scrumColor: scrum.color)
                Circle()
                    .strokeBorder(lineWidth: 24, antialiased: true)
                MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)  // passing speakers and the skip action to MeetingFooterView()
            }
        }
        .padding()
        .foregroundColor(scrum.color.accessibleFontColor)
        .onAppear {
            scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
            // The timer resets each time an instance of MeetingView shows on screen, indicating that a meeting should begin.
            scrumTimer.startScrum()
        }
        .onDisappear {
            scrumTimer.stopScrum()
        }
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.data[0]))
    }
}
