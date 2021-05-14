//
//  MeetingView.swift
//  Scrumdinger
//
//  Created by Madeline Lee on 5/10/21.
//

import SwiftUI
import AVFoundation

struct MeetingView: View {
    @Binding var scrum: DailyScrum // Create a scrum binding
    @StateObject var scrumTimer = ScrumTimer() // Wrapping a property as a @StateObject means the view owns the source of truth for the "object" ("reference type" model). @StateObject ties the ScrumTimer ObservableObject to the MeetingView life cycle (keeps the object alive for the life cycle of a view)
    var player: AVPlayer { AVPlayer.sharedDingPlayer } // the sharedDingPlayer object plays the ding.wav resource
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
            // The timer resets each time an instance of MeetingView shows on screen, indicating that a meeting should begin.
            scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
            
            // ScrumTimer calls this action (a closure) when a speaker’s time expires.
            scrumTimer.speakerChangedAction = {
                //trigger audio feedback when a speaker’s time has ended
                player.seek(to: .zero) // Seeking to time .zero ensures the audio file always plays from the beginning
                player.play()
            }
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
