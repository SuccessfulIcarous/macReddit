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
                .onAppear {
                        self.store.addSubredditAsFavorite(subreddit: SAMPLE_SUBREDDIT)
                    self.store.addSubredditAsFavorite(subreddit: Subreddit(id: "2qhqt", name: "t5_2qhqt", title: " The Arsenal on Reddit", displayName: "Gunners", displayNamePrefixed: "r/Gunners", iconImageUrl: "https://asia-southeast2-macredditbackend.cloudfunctions.net/reddit/v1/styles/t5_2qhqt/styles/communityIcon_ce0k9igr9y771.png?width=256&s=e16eb00e4d22fecc7f2e89d93104cba1b22ca0bc"))
                    self.store.addSubredditAsFavorite(subreddit: Subreddit(id: "2sexa", name: "t5_2sexa", title: "Brazzers", displayName: "Brazzers", displayNamePrefixed: "r/Brazzers", iconImageUrl: "https://asia-southeast2-macredditbackend.cloudfunctions.net/reddit/v1/styles/t5_2sexa/styles/communityIcon_sh4oou6o2vs31.jpg?width=256&s=f7f9c88d3165abd23c3db852b747c9419eb11e1b"))
                }
        }
    }
}
