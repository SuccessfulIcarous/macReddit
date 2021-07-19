//
//  macReddtrApp.swift
//  macReddtr
//
//  Created by Brata on 02/07/21.
//

import SwiftUI
import iReddtrLibrary

@main
struct macReddtrApp: App {
    init() {
        iReddtr.initAPI()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
