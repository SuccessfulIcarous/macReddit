//
//  Listing.swift
//  macReddtr
//
//  Created by Brata on 24/07/21.
//

import Foundation

public struct RedditListingData<T: Codable>: Codable {
    public let after: String?
    public let dist: Int?
    public let modhash: String?
    public let geoFilter: String?
    public let before: String?
    public let children: [T]?
    
    enum CodingKeys: String, CodingKey {
        case after, dist, modhash
        case geoFilter = "geo_filter"
        case before, children
    }
}
