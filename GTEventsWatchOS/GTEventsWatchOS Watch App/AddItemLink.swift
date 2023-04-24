//
//  AddItemLink.swift
//  GTEventsWatchOS Watch App
//
//  Created by Jessie Zhao on 4/24/23.
//

import SwiftUI

struct AddItemLink: View {
    @EnvironmentObject private var model: ItemListModel

    var body: some View {
        VStack{
            TextFieldLink{
                Label(
                    "Add",
                    systemImage: "plus.circle.fill"
                        )
            } onSubmit: {                 model.items.append(ListItem($0))
            }
            .foregroundColor(.blue)
        }

    }
}

struct AddItemLink_Previews: PreviewProvider {
    static var previews: some View {
        AddItemLink()
    }
}
