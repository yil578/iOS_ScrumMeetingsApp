//
//  ScrumData.swift
//  Scrumdinger
//
//  Created by Madeline Lee on 5/14/21.
//

import Foundation

class ScrumData: ObservableObject {
    
    // private static computed property. Scrumdinger will load and save scrums to a file in the user’s Documents folder.
    private static var documentsFolder: URL {
        // use the shared instance of the FileManager class to get the location of the Documents directory for the current user.
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find documents directory.")
            // Add a do-"catch" statement to handle possible errors because url(for:in:appropriateFor:create:) is a "throwing function".
        }
    }
    
    // read-only property
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("scrums.data")
    }
    
    @Published var scrums: [DailyScrum] = [] // !!!NOTE: An ObservableObject includes an objectWillChange publisher that emits when/before one of its @Published properties is about to change. Any "view observing an instance of ScrumData (an ObservableObject, as @ObservedObject property in the View) will re-render" when the scrums value changes.
    
    func load() {
        // Use dispatch queues (FIFO, to which your application can submit tasks. Background tasks have the lowest priority of all tasks) to choose which tasks run on the main thread or background threads
        // Request a "global queue" with a "background quality of service" (i.e. backgroud queue)
        // async block that will execute asynchronously on the queue
        // use a weak reference to self inside the closure to avoid a retain cycle
        DispatchQueue.global(qos: .background).async { [weak self] in
            // use the Data structure to read from and write to the file system
            // Data(contentsOf:options) can fail, so you use optional binding to unwrap Data (try expression returns an optional upon failure)
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                /*
                 You’ll use the #if DEBUG compiler directive to ensure that you have sample scrums to work with while you develop the app. Code inside the block is excluded from releases.
                 */
                #if DEBUG
                // On the "main queue"!!, set scrums equal to DailyScrum.data (Important! Always perform "UI updates" on the main queue!!)
                DispatchQueue.main.async {
                    self?.scrums = DailyScrum.data
                }
                #endif
                return
            }
            
            // Use a JSONDecoder instance to decode the scrum data. Halt execution if no value is returned.
            guard let dailyScrums = try? JSONDecoder().decode([DailyScrum].self, from: data) else {
                fatalError("Can't decode saved scrum data.")
            }
            
            DispatchQueue.main.async { // On the main queue, set scrums equal to dailyScrums
                self?.scrums = dailyScrums
            }
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            // In a background queue, check that self is in scope. Halt execution if scrums is out of scope.
            guard let scrums = self?.scrums else { fatalError("Self out of scope") }
            
            // Use a JSONEncoder instance to encode scrums. Halt execution if scrums isn't encoded.
            guard let data = try? JSONEncoder().encode(scrums) else { fatalError("Error encoding data") }
            
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile) // write(to:options:) is a "throwing function", so you handle any errors in a "catch" clause.
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
}
