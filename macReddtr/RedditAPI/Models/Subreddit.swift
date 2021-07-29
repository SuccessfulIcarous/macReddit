//
//  Subreddit.swift
//  macReddtr
//
//  Created by Brata on 24/07/21.
//

import Foundation

public struct SubredditListing: Codable {
    public let data: RedditListingData<SubredditKind>?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

public struct SubredditKind: Codable {
    public let data: SubredditData?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

public struct SubredditData: Codable, Identifiable {
    public let id: String
    public let name: String?
    public let title: String?
    public let displayName: String?
    public let displayNamePrefixed: String?
    public let iconImg: String?
    public let communityIcon: String?
    
    enum CodingKeys: String, CodingKey {
        case name, title, id
        case displayName = "display_name"
        case displayNamePrefixed = "display_name_prefixed"
        case iconImg = "icon_img"
        case communityIcon = "community_icon"
    }
    
    @available(*, deprecated, message: "Don't use this anymore")
    public func getSubredditName() -> String {
        return self.displayNamePrefixed ?? ""
    }
    
    @available(*, deprecated, message: "Don't use this anymore")
    public func getSubredditShortDesc() -> String {
        return self.title ?? ""
    }
    
    @available(*, deprecated, message: "Don't use this anymore")
    public func getSubredditIcon() -> String {
        return chooseSubredditIcon()
    }
    
    func chooseSubredditIcon() -> String {
        var iconUrl = ""
        if let communityIcon = self.communityIcon, !communityIcon.isEmpty {
            iconUrl = communityIcon
        } else if let defaultIcon = self.iconImg, !defaultIcon.isEmpty {
            iconUrl = defaultIcon
        } else {
            iconUrl = ""
        }
        return getMediaUrl(url: iconUrl)
    }
    
    public func toSubreddit() -> Subreddit {
        let icon = chooseSubredditIcon()
        return Subreddit(
            id: self.id,
            name: self.name ?? "",
            title: self.title ?? "",
            displayName: self.displayName ?? "",
            displayNamePrefixed: self.displayNamePrefixed ?? "",
            iconImageUrl: icon
        )
    }
}

public struct Subreddit {
    public init(id: String, name: String, title: String, displayName: String, displayNamePrefixed: String, iconImageUrl: String) {
        self.id = id
        self.name = name
        self.title = title
        self.displayName = displayName
        self.displayNamePrefixed = displayNamePrefixed
        self.iconImageUrl = iconImageUrl
    }
    
    public let id: String
    public let name: String
    public let title: String
    public let displayName: String
    public let displayNamePrefixed: String
    public let iconImageUrl: String
}

extension Subreddit: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public extension Array where Element == Subreddit {
    func concatenateAllSubredditName() -> String {
        if self.isEmpty {
            return ""
        }
        return self.map { $0.displayName }.joined(separator: ",")
    }
}
