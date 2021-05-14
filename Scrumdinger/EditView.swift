//
//  EditView.swift
//  Scrumdinger
//
//  Created by Madeline Lee on 5/11/21.
//

import SwiftUI

struct EditView: View {
    /*
     You’ll store changes to the scrum in the scrumData property (DailyScrum.Data type). You’ll define the property using the "@State wrapper" because you need to mutate the propert from "within the view".
     SwiftUI observes @State properties and "automatically redraws" the view’s body when the property changes.
     
     Each piece of data that you use in your view hierarchy should have a single source of truth. You can use the "@State property wrapper" to define the source of truth for "value types".
     
     Note: Declare @State properties as "private" so they can be accessed only "within the view" in which you define them.
     */
    //@State private var scrumData: DailyScrum.Data = DailyScrum.Data()
    @Binding var scrumData: DailyScrum.Data // Use @Binding to share write access to a state "with other views". Also because scrumData is now passed in during initialization, you need to remove the private attribute and DailyScrum.Data initialization.
    @State private var newAttendee = "" // The newAttendee property will hold the attendee name the user enters
    var body: some View {
        List {
            Section(header: Text("Meeting Info")) {
                TextField("Title", text: $scrumData.title)
                /*
                 TextField takes a binding to a String. A binding is a reference to a state that is owned by another view. You access a binding to scrumData.title with the expression $scrumData.title.
                 */
                HStack {
                    Slider(value: $scrumData.lengthInMinutes, in: 5...30, step: 1.0) {
                        Text("Length") // In the slider’s label closure, add a Text view for accessibility use. this won’t appear on screen, but VoiceOver uses it to identify the purpose of the slider.
                    }
                    .accessibilityValue(Text("\(Int(scrumData.lengthInMinutes)) minutes"))
                    Spacer()
                    Text("\(Int(scrumData.lengthInMinutes)) minutes")
                        .accessibilityHidden(true)
                }
                ColorPicker("Color", selection: $scrumData.color)
                    .accessibilityLabel(Text("Color picker")) // The color picker has the “button” accessibility trait, so don’t include the word “button” in the label
            }
            Section(header: Text("Attendees")) {
                ForEach(scrumData.attendees, id: \.self) { attendee in
                    Text(attendee) //display each attendee in a Text view
                }
                // The framework calls the closure you pass to onDelete (remove attendee from the scrumData) when the user swipes to delete a row
                .onDelete { indices in
                    scrumData.attendees.remove(atOffsets: indices)
                }
                HStack {
                    TextField("New Attendee", text: $newAttendee) // pass a binding to the newAttendee property
                    Button(action: {
                        withAnimation {
                            scrumData.attendees.append(newAttendee)
                            newAttendee = "" // Because the text field has a binding to newAttendee, setting the value to the empty string also clears the contents of the text field.
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel(Text("Add attendee"))
                    }
                    .disabled(newAttendee.isEmpty)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        //EditView()
        EditView(scrumData: .constant(DailyScrum.data[0].data)) // Pass a "constant" binding to the EditView initializer
        // You can use the "constant(_:) type method" to create a binding to a hard-coded, immutable value. Constant bindings are useful in previews or when you’re prototyping your app’s UI
    }
}
