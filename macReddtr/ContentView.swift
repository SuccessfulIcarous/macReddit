//
//  ContentView.swift
//  macReddtr
//
//  Created by Brata on 02/07/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            SidebarView()
            SearchSubRedditView()
            SubRedditDetailView()
        }
        .frame(minWidth: 1400)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 800, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
    }
}
