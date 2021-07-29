//
//  Post.swift
//  macReddtr
//
//  Created by Brata on 29/07/21.
//

import Foundation

public struct PostListing: Codable {
    public let data: RedditListingData<PostKind>?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

public struct PostKind: Codable {
    public let data: PostData?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

public struct PostData: Codable, Identifiable {
    public let id: String?
    public let name: String?
    public let title: String?
    public let url: String?
    public let subredditNamePrefixed: String?
    public let isVideo: Bool?
    public let selftext: String?
    public let selftextHtml: String?
    
    enum CodingKeys: String, CodingKey {
        case title, name, id, url, selftext
        case subredditNamePrefixed = "subreddit_name_prefixed"
        case isVideo = "is_video"
        case selftextHtml = "selftext_html"
    }
    
    public func toPost() -> Post {
        return Post(id: self.id ?? "", name: self.name ?? "", title: self.title ?? "", url: self.url ?? "", subredditNamePrefixed: self.subredditNamePrefixed ?? "", isVideo: self.isVideo ?? false, selftext: self.selftext ?? "", selftextHtml: self.selftextHtml ?? "")
    }
}

public struct Post: Identifiable {
    public init(id: String, name: String, title: String, url: String, subredditNamePrefixed: String, isVideo: Bool, selftext: String, selftextHtml: String) {
        self.id = id
        self.name = name
        self.title = title
        self.url = url
        self.subredditNamePrefixed = subredditNamePrefixed
        self.isVideo = isVideo
        self.selftext = selftext
        self.selftextHtml = selftextHtml
    }
    
    public let id: String
    public let name: String
    public let title: String
    public let url: String
    public let subredditNamePrefixed: String
    public let isVideo: Bool
    public let selftext: String
    public let selftextHtml: String
}

extension Post: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
