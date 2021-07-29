//
//  GlobalStore.swift
//  macReddtr
//
//  Created by Brata on 25/07/21.
//

import Foundation
import Combine

class GlobalStore: ObservableObject {
    private var cancellables: Set<AnyCancellable>! = []
    
    @Published var favoritedSubreddits = [Subreddit]()
    @Published var selectedSidebar: Int?
    @Published var selectedSubreddit: Subreddit?
    
    public let api = RedditAPI()
    
    public func addSubredditAsFavorite(subreddit: Subreddit) {
        api.markAsFavorite(subReddit: subreddit)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    print(err)
                }
            },  receiveValue: { value in
                self.favoritedSubreddits.removeAll()
                self.favoritedSubreddits.append(contentsOf: value)
            })
            .store(in: &cancellables)
    }
}
