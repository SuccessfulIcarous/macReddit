//
//  OfflineDataSourceTests.swift
//  macReddtrTests
//
//  Created by Brata on 24/07/21.
//

import XCTest
import Combine
import macReddtr

class InMemoryOfflineDataSourceTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func testInitWithEmptyData() {
        let dataSource = InMemoryOfflineDataSource()
        XCTAssertEqual(dataSource.subscribedSubreddit.count, 0)
    }
    
    func testSubscribingWhenEmpty() {
        var actualValue: Bool?
        var error: Error?
        let expectation = self.expectation(description: "testSubscribingWhenEmpty")
        
        let dataSource = InMemoryOfflineDataSource()
        let subreddit = Subreddit(id: "1", name: "", title: "", displayName: "", displayNamePrefixed: "", iconImageUrl: "")
        dataSource.subscribeTo(subReddit: subreddit)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                
                expectation.fulfill()
            }, receiveValue: { value in
                actualValue = value
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        XCTAssertEqual(true, actualValue)
    }
    
    func testSubscribingWhenNotEmpty() {
        var actualValue: Bool?
        var error: Error?
        let expectation = self.expectation(description: "testSubscribingWhenEmpty")
        
        let dataSource = InMemoryOfflineDataSource()
        let subreddit1 = Subreddit(id: "1", name: "", title: "", displayName: "", displayNamePrefixed: "", iconImageUrl: "")
        let subreddit2 = Subreddit(id: "2", name: "", title: "", displayName: "", displayNamePrefixed: "", iconImageUrl: "")
        dataSource.subscribeTo(subReddit: subreddit1)
            .flatMap { value in
                return dataSource.subscribeTo(subReddit: subreddit2)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                
                expectation.fulfill()
            }, receiveValue: { value in
                actualValue = value
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        XCTAssertEqual(true, actualValue)
    }
    
    func testSubscribingWhenDuplicated() {
        var actualValue: Bool?
        var error: Error?
        let expectation = self.expectation(description: "testSubscribingWhenDuplicated")
        
        let dataSource = InMemoryOfflineDataSource()
        let subreddit = Subreddit(id: "1", name: "", title: "", displayName: "", displayNamePrefixed: "", iconImageUrl: "")
        dataSource.subscribeTo(subReddit: subreddit)
            .flatMap { value in
                return dataSource.subscribeTo(subReddit: subreddit)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                
                expectation.fulfill()
            }, receiveValue: { value in
                actualValue = value
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        XCTAssertEqual(false, actualValue)
    }
    
    func testGetSubscriptionWhenEmpty() {
        var actualValue: [Subreddit]?
        var error: Error?
        let expectation = self.expectation(description: "testGetSubscriptionWhenEmpty")
        
        let dataSource = InMemoryOfflineDataSource()
        dataSource.getSubscribedSubReddits()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                
                expectation.fulfill()
            }, receiveValue: { value in
                actualValue = value
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        XCTAssertNotNil(actualValue)
        XCTAssertEqual([], actualValue!)
    }
    
    func testGetSubscriptionWhenNotEmpty() {
        var actualValue: [Subreddit]?
        var error: Error?
        let expectation = self.expectation(description: "testGetSubscriptionWhenNotEmpty")
        
        let dataSource = InMemoryOfflineDataSource()
        let subreddit1 = Subreddit(id: "1", name: "", title: "", displayName: "", displayNamePrefixed: "", iconImageUrl: "")
        let subreddit2 = Subreddit(id: "2", name: "", title: "", displayName: "", displayNamePrefixed: "", iconImageUrl: "")
        dataSource.subscribeTo(subReddit: subreddit1)
            .flatMap { _ in
                return dataSource.subscribeTo(subReddit: subreddit2)
            }
            .flatMap { _ in
                return dataSource.getSubscribedSubReddits()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                
                expectation.fulfill()
            }, receiveValue: { value in
                actualValue = value
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        let expectedValue: Set = [subreddit1, subreddit2]
        XCTAssertNotNil(actualValue)
        XCTAssertEqual(expectedValue, Set<Subreddit>(actualValue!))
    }
}
