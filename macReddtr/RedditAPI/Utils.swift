//
//  Utils.swift
//  macReddtr
//
//  Created by Brata on 24/07/21.
//

import Foundation

func getMediaUrl(url: String, usingBaseUrl _baseUrl: String = Endpoint.PublicProxyReddit.rawValue) -> String {
    let unescapedUrlString = url.replacingOccurrences(of: "&amp;", with: "&")
    if (unescapedUrlString.contains("https://styles.redditmedia.com")) {
        return unescapedUrlString.replacingOccurrences(of: "https://styles.redditmedia.com", with: "\(_baseUrl)/styles")
    } else if (unescapedUrlString.contains("a.thumbs.redditmedia.com")) {
        return unescapedUrlString.replacingOccurrences(of: "https://a.thumbs.redditmedia.com", with: "\(_baseUrl)/athumbs")
    } else if (unescapedUrlString.contains("b.thumbs.redditmedia.com")) {
        return unescapedUrlString.replacingOccurrences(of: "https://b.thumbs.redditmedia.com", with: "\(_baseUrl)/bthumbs")
    } else if (unescapedUrlString.contains("c.thumbs.redditmedia.com")) {
        return unescapedUrlString.replacingOccurrences(of: "https://c.thumbs.redditmedia.com", with: "\(_baseUrl)/cthumbs")
    } else if (unescapedUrlString.contains("d.thumbs.redditmedia.com")) {
        return unescapedUrlString.replacingOccurrences(of: "https://d.thumbs.redditmedia.com", with: "\(_baseUrl)/dthumbs")
    } else if (unescapedUrlString.contains("e.thumbs.redditmedia.com")) {
        return unescapedUrlString.replacingOccurrences(of: "https://e.thumbs.redditmedia.com", with: "\(_baseUrl)/ethumbs")
    } else if (unescapedUrlString.contains("f.thumbs.redditmedia.com")) {
        return unescapedUrlString.replacingOccurrences(of: "https://f.thumbs.redditmedia.com", with: "\(_baseUrl)/fthumbs")
    } else if (unescapedUrlString.contains("g.thumbs.redditmedia.com")) {
        return unescapedUrlString.replacingOccurrences(of: "https://g.thumbs.redditmedia.com", with: "\(_baseUrl)/gthumbs")
    }
    return unescapedUrlString
}
