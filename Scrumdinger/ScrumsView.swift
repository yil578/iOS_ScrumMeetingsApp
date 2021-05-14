//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Madeline Lee on 5/11/21.
//


import SwiftUI

struct ScrumsView: View {
    //let scrums: [DailyScrum]
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase // SwiftUI indicates the current operational state of your app’s "Scene" instances with a scenePhase Environment value. "Observe this value" and save user data when it becomes inactive.
    
    @State private var isPresented = false // when true, presents EditView
    @State private var newScrumData = DailyScrum.Data()
    
    let saveAction: () -> Void // constant closure property
    
    var body: some View {
        List {
            // id: \.title - key path to the title property
            ForEach(scrums) { scrum in //ForEach must return a view for each item it traverses
                NavigationLink(destination: DetailView(scrum: binding(for: scrum))) { // 1st Navigation (to DetailView)
                    CardView(scrum: scrum)
                }
                .listRowBackground(scrum.color)
            }
        }
        .navigationTitle("Daily Scrums")
        .navigationBarItems(trailing: Button(action: {
            // Changing isPresented to true causes the sheet to be presented
            isPresented = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $isPresented) { // partially cover the underlying screen
            NavigationView { // 2nd Navigation (to EditView)
                EditView(scrumData: $newScrumData)
                    .navigationBarItems(leading: Button("Dismiss") {
                        isPresented = false
                    }, trailing: Button("Add") {
                        // Create a new DailyScrum and add to scrums array!! (source of truth throughout the entire app), WOW!!!
                        let newScrum = DailyScrum(title: newScrumData.title, attendees: newScrumData.attendees,
                                                                          lengthInMinutes: Int(newScrumData.lengthInMinutes), color: newScrumData.color)
                        scrums.append(newScrum)
                        isPresented = false
                    })
            }
        }
        // observing the scenePhase value
        .onChange(of: scenePhase) { phase in
            // when the scenephase becomes inactive, call saveAction()
            if phase == .inactive { saveAction() }
            // An inactive scene doesn’t receive events and should free any unnecessary resources, and may be unavailable to the user
        }
    }
    
    // a utility method to retrieve a binding from an individual scrum
    private func binding(for scrum: DailyScrum) -> Binding<DailyScrum> {
        guard let scrumIndex = scrums.firstIndex(where: { $0.id == scrum.id }) else {
            fatalError("Can't find scrum in array") // Halt execution if the scrum doesn’t exist in the scrums array.
        }
        return $scrums[scrumIndex] // returning a binding to the scrum. The $ prefix accesses the projected value of a "wrapped property". The projected value of the "scrums binding" is "another binding".
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            //ScrumsView(scrums: DailyScrum.data)
            ScrumsView(scrums: .constant(DailyScrum.data), saveAction: {}) //pass a constant binding to the ScrumsView initializer and empty closure for saveAction argument
        }
    }
}
