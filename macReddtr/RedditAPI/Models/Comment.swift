//
//  Comment.swift
//  macReddtr
//
//  Created by Brata on 30/07/21.
//

import Foundation

public struct CommmentListing: Codable {
    public let data: RedditListingData<CommentKind>?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    public static func createFrom(json: [String: Any]?) -> CommmentListing? {
        if let json = json {
            if let data = json["data"] as? [String: Any] {
                if let children = data["children"] as? [[String: Any]] {
                    return CommmentListing(
                        data: RedditListingData(
                            after: nil, dist: nil, modhash: nil, geoFilter: nil, before: nil, children: children.compactMap({ item in
                                CommentKind.createFrom(json: item)
                            })
                        )
                    )
                }
                return CommmentListing(
                    data: RedditListingData(
                        after: nil, dist: nil, modhash: nil, geoFilter: nil, before: nil,
                        children: nil
                    )
                )
            }
        }
        return nil
    }
}

public struct CommentKind: Codable {
    public let data: CommentData?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    public static func createFrom(json: [String: Any]?) -> CommentKind? {
        if let json = json {
            return CommentKind(
                data: CommentData.createFrom(json["data"] as? [String: Any])
            )
        }
        return nil
    }
}

public struct CommentData: Codable, Identifiable {
    public let id: String?
    public let name: String?
    public let body: String?
    public let replies: CommmentListing?
    
    enum CodingKeys: String, CodingKey {
        case id, name, body, replies
    }
    
    public static func createFrom(_ json: [String: Any]?) -> CommentData? {
        if let json = json {
            return CommentData(
                id: json["id"] as? String, name: json["name"] as? String, body: json["body"] as? String,
                replies: CommmentListing.createFrom(json: json["replies"] as? [String: Any])
            )
        }
        return nil
    }
    
    public func printComment() {
        print("·\(body ?? "")")
        printReplies(reply: replies, depth: 1)
    }
    
    private func printReplies(reply: CommmentListing?, depth: Int) {
        if let replies = reply?.data?.children {
            for reply in replies {
                if let replyData = reply.data {
                    print("\(getIndent(depth))\(replyData.body ?? "")")
                    printReplies(reply: replyData.replies, depth: depth + 1)
                }
            }
        }
    }
    
    private func getIndent(_ depth: Int) -> String {
        var indent = ""
        for _ in 0..<depth {
            indent += "\t"
        }
        return indent
    }
}
