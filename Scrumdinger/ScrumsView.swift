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
    var body: some View {
        List {
            // id: \.title - key path to the title property
            ForEach(scrums) { scrum in //ForEach must return a view for each item it traverses
                NavigationLink(destination: DetailView(scrum: binding(for: scrum))) { //Pass a binding to the DetailView initializer
                    CardView(scrum: scrum)
                }
                .listRowBackground(scrum.color)
            }
        }
        .navigationTitle("Daily Scrums")
        .navigationBarItems(trailing: Button(action: {}) {
            Image(systemName: "plus")
        })
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
            ScrumsView(scrums: .constant(DailyScrum.data)) //pass a constant binding to the ScrumsView initializer
        }
    }
}
