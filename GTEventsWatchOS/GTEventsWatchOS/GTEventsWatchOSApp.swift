//
//  GTEventsWatchOSApp.swift
//  GTEventsWatchOS
//
//  Created by Jessie Zhao on 4/24/23.
//

import SwiftUI
struct ListItem: Identifiable, Hashable{
    let id = UUID()
    var description: String
    
    init(_ description: String) {
        self.description = description
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
