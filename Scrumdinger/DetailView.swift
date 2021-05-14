//
//  DetailView.swift
//  Scrumdinger
//
//  Created by Madeline Lee on 5/11/21.
//

import SwiftUI

struct DetailView: View {
    //let scrum: DailyScrum
    @Binding var scrum: DailyScrum // convert constant -> binding. Using a binding ensures that "DetailView re-renders" when scrum is modified!!!
    @State private var data: DailyScrum.Data = DailyScrum.Data() //initialized using empty initializer (default values for now, will be populated in line 49 from the actual scrum)
    @State private var isPresented = false
    var body: some View {
        List {
            Section(header: Text("Meeting Info")) {
                NavigationLink(destination: MeetingView()) { //1st Navigation in DetailView (to MeetingView)
                    Label("Start Meeting", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .accessibilityLabel(Text("Start meeting"))
                }
                HStack {
                    Label("Length", systemImage: "clock")
                        .accessibilityLabel(Text("Meeting length"))
                    Spacer()
                    Text("\(scrum.lengthInMinutes) minutes")
                }
                HStack {
                    Label("Color", systemImage: "paintpalette")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(scrum.color)
                }
                .accessibilityElement(children: .ignore)
            }
            Section(header: Text("Attendees")) {
                ForEach(scrum.attendees, id: \.self) { attendee in
                    Label(attendee, systemImage: "person")
                        .accessibilityLabel(Text("Person"))
                        .accessibilityValue(Text(attendee))
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button("Edit") {
            isPresented = true
            data = scrum.data //WOW!!!
        })
        .navigationTitle(scrum.title)
        .fullScreenCover(isPresented: $isPresented) { // The "fullScreenCover modifier" takes a binding to a Bool and a view builder. When isPresented changes to true, the app modally presents EditView using the entire screen. Can use the sheet modifier to present a modal that only partially covers the underlying content.
            NavigationView { //2nd Navigation in DetailView (to EditView)
                EditView(scrumData: $data) // Modifications a user makes to scrumData in the edit view are now shared with the data property in the detail view
                    .navigationTitle(scrum.title) //COOL!
                    .navigationBarItems(leading: Button("Cancel") {
                        isPresented = false
                    }, trailing: Button("Done") {
                        isPresented = false
                        scrum.update(from: data) //WOW!!!
                    })
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            //DetailView(scrum: DailyScrum.data[0])
            DetailView(scrum: .constant(DailyScrum.data[0])) //Pass a constant binding to the DetailView initializer
        }
    }
}
