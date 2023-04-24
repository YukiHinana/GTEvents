//
//  ContentView.swift
//  GTEventsWatchOS Watch App
//
//  Created by Jessie Zhao on 4/24/23.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject private var model: ItemListModel
    var body: some View {
                List($model.items) {$item in Text(item.description)
            }
            .toolbar{
                AddItemLink()
            }
//            if model.items.isEmpty{
//                Text("No events")
//                    .foregroundColor(.red)
//            }
        
        .navigationTitle("GTEvents")
        //        VStack {
        //            Image(systemName: "globe")
        //                .imageScale(.large)
        //                .foregroundColor(.accentColor)
        //            Text("GTEvents")
        //        }
        //        .padding()
        //    }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

