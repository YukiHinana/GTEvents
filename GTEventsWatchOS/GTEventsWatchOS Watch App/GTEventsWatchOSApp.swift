//
//  GTEventsWatchOSApp.swift
//  GTEventsWatchOS Watch App
//
//  Created by Jessie Zhao on 4/24/23.
//

import SwiftUI
struct ListItem: Identifiable, Hashable{
    let id = UUID()
    var description: String
//    var estimatedWork: Int
//    var creationDate: Date = Date()
//    var completionDate: Date?
//
    
    init(_ description: String) {
        self.description = description
//        self.estimatedWork = estimatedWork
//        self.creationDate = creationDate

    }

}
class ItemListModel: NSObject, ObservableObject {
    
    @Published var items = [ListItem]()

}



@main

struct GTEventsWatchOSApp: App {
    @StateObject var itemListModel = ItemListModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ContentView()
                .environmentObject(itemListModel)
                
            }
        }
    }
}
