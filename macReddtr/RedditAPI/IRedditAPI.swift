//
//  RedditAPI.swift
//  macReddtr
//
//  Created by Brata on 24/07/21.
//

import Foundation
import Combine

protocol IRedditAPI {
    func searchSubreddits(query: String, limit: Int, nsfw: Bool, resultQueue: DispatchQueue) throws -> AnyPublisher<SubredditListing, Error>
    func getFavoritedSubreddits(resultQueue: DispatchQueue) -> AnyPublisher<[Subreddit], Error>
    func markAsFavorite(subReddit: Subreddit, resultQueue: DispatchQueue) -> AnyPublisher<[Subreddit], Error>
    func getPostsFor(subredditNames: [String], params: APIParam, resultQueue: DispatchQueue) throws -> AnyPublisher<PostListing, Error>
}

public class APIParam {
    private var limit: Int = 0
    private var nsfw: Bool = true
    public private(set) var sortType: SortType = .best
    private var after: String = ""
    private var before: String = ""
    
    public init() {}
    
    public func setLimit(_ val: Int) -> APIParam {
        self.limit = val
        return self
    }
    
    public func setSortType(_ val: SortType) -> APIParam {
        self.sortType = val
        return self
    }
    
    public func setAfter(_ val: String) -> APIParam {
        self.after = val
        return self
    }
    
    public func asQueryParam() -> [String: Any] {
        return [
            "raw_json": 1,
            "limit": self.limit,
            "include_over_18": self.nsfw ? 1 : 0,
            "after": self.after,
            "before": self.before
        ]
    }
}
