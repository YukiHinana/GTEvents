//
//  ItemDetail.swift
//  GTEventsWatchOS Watch App
//
//  Created by Jessie Zhao on 4/24/23.
//
//
//import SwiftUI
//
//struct ItemDetail: View {
//    @Binding var item: ListItem
//
//    var body: some View {
//        Form {
//            Section("List Item") {
//                TextField("Item", text: $item.description, prompt: Text("List Item"))
//            }
//
//            Toggle(isOn: $item.isComplete){
//                Text("Completed")
//            }
//        }
//    }
//}
//
//struct ItemDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemDetail()
//    }
//}
