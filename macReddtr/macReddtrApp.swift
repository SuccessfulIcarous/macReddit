//
//  macReddtrApp.swift
//  macReddtr
//
//  Created by Brata on 02/07/21.
//

import SwiftUI
//import iReddtrLibrary

@main
struct macReddtrApp: App {
    @StateObject private var store = GlobalStore()
    
    init() {
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
