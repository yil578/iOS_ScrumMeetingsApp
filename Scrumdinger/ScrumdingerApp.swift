//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Madeline Lee on 5/10/21.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @State private var scrums = DailyScrum.data //add a private @State property named scrums
    
    // The app’s body property returns a Scene that contains a view hierarchy representing the primary user interface/initial view for the app.
    var body: some Scene {
        WindowGroup { // WindowGroup scene: a window that fills the device’s entire screen
            NavigationView { // traverse a stack of views in a hierarchy, display navigation elements
                //ScrumsView(scrums: DailyScrum.data)
                ScrumsView(scrums: $scrums) //Pass a binding to scrums to the ScrumsView initializer
            }
        }
    }
}
