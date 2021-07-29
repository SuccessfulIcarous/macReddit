//
//  AppViewModel.swift
//  macReddtr
//
//  Created by Brata on 24/07/21.
//

import Foundation
import iReddtrLibrary

class AppViewModel: ObservableObject {
    enum SidebarSelection {
        case AllReddit
        case SingleReddit(Subreddit)
    }
    
    enum PostSelectionState {
        case None
        case Selected(String)
    }
    
    @Published public private(set) var selectedSidebarOption: SidebarSelection = SidebarSelection.AllReddit
    @Published public private(set) var selectedPost: PostSelectionState = PostSelectionState.None
    @Published public private(set) var favoriteSubreddits: [Subreddit] = []
    
    public func updateFavoriteSubreddits(_ subreddit: [Subreddit]) {
        self.favoriteSubreddits.removeAll()
        self.favoriteSubreddits.append(contentsOf: subreddit)
    }
    
    public func selectSidebar(_ selection: SidebarSelection) {
        self.selectedSidebarOption = selection
    }
}
