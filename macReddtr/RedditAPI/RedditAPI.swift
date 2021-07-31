//
//  RedditAPI.swift
//  macReddtr
//
//  Created by Brata on 24/07/21.
//

import Foundation
import Combine

public typealias HttpCallback<T : Codable> = (HttpResult<T>) -> Void

public class RedditAPI: IRedditAPI {
    public init(withEndpoint endpoint: Endpoint = Endpoint.PublicProxyReddit, withDataSource offlineDataSource: OfflineDataSource = InMemoryOfflineDataSource()) {
        self._endpoint = endpoint
        self._offlineDataSource = offlineDataSource
    }
    
    private let _endpoint: Endpoint
    private let _offlineDataSource: OfflineDataSource
    
    public func getFavoritedSubreddits(resultQueue: DispatchQueue = DispatchQueue.main) -> AnyPublisher<[Subreddit], Error> {
        _offlineDataSource.getSubscribedSubReddits()
            .receive(on: resultQueue)
            .eraseToAnyPublisher()
    }
    
    public func markAsFavorite(subReddit: Subreddit, resultQueue: DispatchQueue = DispatchQueue.main) -> AnyPublisher<[Subreddit], Error> {
        _offlineDataSource.subscribeTo(subReddit: subReddit)
            .flatMap { _ in
                self._offlineDataSource.getSubscribedSubReddits()
            }
            .receive(on: resultQueue)
            .eraseToAnyPublisher()
    }
    
    public func searchSubreddits(query: String, limit: Int, nsfw: Bool, resultQueue: DispatchQueue = DispatchQueue.main) -> AnyPublisher<SubredditListing, Error> {
        let queryParams: [String: Any] = [
            "raw_json": 1,
            "q": query,
            "include_over_18": nsfw ? 1 : 0,
            "limit": limit
        ]
        let url = self.getAPIUrl(path: ApiPath.searchSubreddits)
        guard var urlComponents = URLComponents(string: url) else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
        urlComponents.setQueryItems(with: queryParams)
        guard let url = urlComponents.url else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
        let request = self.createGetRequest(url: url)
        return performGet(request)
            .receive(on: resultQueue)
            .eraseToAnyPublisher()
    }
    
    public func getPostsFor(subredditNames: [String], params: APIParam, resultQueue: DispatchQueue = .main) -> AnyPublisher<PostListing, Error> {
        let url = self.getAPIUrl(path: .getSubredditPost, subredditNames: subredditNames, sortType: params.sortType)
        let queryParams = params.asQueryParam()
        guard var urlComponents = URLComponents(string: url) else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
        urlComponents.setQueryItems(with: queryParams)
        guard let finalUrl = urlComponents.url else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
        let request = self.createGetRequest(url: finalUrl)
        return performGet(request)
            .receive(on: resultQueue)
            .eraseToAnyPublisher()
    }
    
    public func getCommentsFor(postName: String, params: APIParam, resultQueue: DispatchQueue = .main) -> AnyPublisher<CommmentListing, Error> {
        let url = self.getAPIUrl(path: .getComments, subredditNames: [postName])
        let queryParams = params.asQueryParam()
        guard var urlComponents = URLComponents(string: url) else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
        urlComponents.setQueryItems(with: queryParams)
        guard let finalUrl = urlComponents.url else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
        let request = self.createGetRequest(url: finalUrl)
        return performGetDictionary(request)
            .tryMap({ json in
                let commentListing = json[1]
                let listing = CommmentListing.createFrom(json: commentListing)
                return listing ?? CommmentListing(data: nil)
            })
            .receive(on: resultQueue)
            .eraseToAnyPublisher()
    }
    
    func performGetDictionary(_ request: URLRequest) -> AnyPublisher<[[String: Any]], Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data: Data, response: URLResponse) in
                guard let httpResponse = (response as? HTTPURLResponse), (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.nonOkHttpResponse
                }
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                    throw APIError.cannotDeserialiseJson
                }
                return json
            }
            .eraseToAnyPublisher()
    }
    
    func performGet<T : Codable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data: Data, response: URLResponse) in
                guard let httpResponse = (response as? HTTPURLResponse), (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.nonOkHttpResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getAPIUrl(path: ApiPath, subredditNames: [String] = [], sortType: SortType = .best) -> String {
        let subredditPath = "{subreddits}"
        let sortPath = "{sort}"
        let postId = "{id}"
        switch path {
        case .searchSubreddits:
            return "\(self._endpoint.rawValue)/api\(path.rawValue)"
        case .getSubredditPost:
            return "\(self._endpoint.rawValue)/api\(path.rawValue)"
                .replacingOccurrences(of: subredditPath, with: subredditNames.joined(separator: "+"))
                .replacingOccurrences(of: sortPath, with: sortType.rawValue)
        case .getComments:
            return "\(self._endpoint.rawValue)/api\(path.rawValue)"
                .replacingOccurrences(of: postId, with: subredditNames.joined(separator: ""))
        }
    }
    
    func createGetRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET.rawValue
        return request
    }
}

public enum HttpResult<T> {
    case Success(T)
    case Error(Error)
}

public enum APIError: Error {
    case invalidUrl
    case cannotDeserialiseJson
    case nonOkHttpResponse
}

enum ApiPath: String {
    case searchSubreddits = "/subreddits/search.json"
    case getSubredditPost = "/r/{subreddits}/{sort}.json"
    case getComments = "/comments/{id}.json"
}

public enum SortType: String {
    case best = "best"
    case new = "new"
}

enum HttpMethod: String {
    case GET, POST
}
