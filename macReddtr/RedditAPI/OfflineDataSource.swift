//
//  OfflineDataSource.swift
//  macReddtr
//
//  Created by Brata on 24/07/21.
//

import Foundation
import Combine

public protocol OfflineDataSource {
    func subscribeTo(subReddit : Subreddit) -> AnyPublisher<Bool, Error>
    func getSubscribedSubReddits() -> AnyPublisher<[Subreddit], Error>
}

public class InMemoryOfflineDataSource: OfflineDataSource {
    public private(set) var subscribedSubreddit: Set<Subreddit> = []
    
    public init() {
        
    }
    
    public func subscribeTo(subReddit: Subreddit) -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { promise in
            let currentCount = self.subscribedSubreddit.count
            self.subscribedSubreddit.insert(subReddit)
            let newCount = self.subscribedSubreddit.count
            if newCount == currentCount + 1 {
                return promise(.success(true))
            } else {
                return promise(.success(false))
            }
        }.eraseToAnyPublisher()
    }
    
    public func getSubscribedSubReddits() -> AnyPublisher<[Subreddit], Error> {
        Future<[Subreddit], Error> { promise in
            return promise(.success(Array(self.subscribedSubreddit)))
        }.eraseToAnyPublisher()
    }
}
