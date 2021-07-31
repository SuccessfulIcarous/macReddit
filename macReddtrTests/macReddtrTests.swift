//
//  macReddtrTests.swift
//  macReddtrTests
//
//  Created by Brata on 24/07/21.
//

import XCTest
import Combine
import macReddtr

struct WhateverError: Error {
    let message: String
}

class macReddtrTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    
    private func publisher1(_ val: String) -> AnyPublisher<String, Error> {
        Deferred {
            Future<String, Error> { promise in
                if val.contains("fail") {
                    return promise(.failure(WhateverError(message: "contains fail")))
                }
                return promise(.success("\(val)1"))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func test(urlString: String) -> AnyPublisher<[String: Any], Error> {
        guard let url = URL(string: urlString) else {
            print("here")
            return Fail(error: WhateverError(message: "invalid url")).eraseToAnyPublisher()
        }
        print("here2")
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError({ $0 as Error })
            .flatMap({ output -> AnyPublisher<[String:Any], Error> in
                guard let json = try? JSONSerialization.jsonObject(with: output.data, options: []) as? [String: Any] else {
                    return Fail(error: WhateverError(message: "cannot decode json")).eraseToAnyPublisher()
                }
                return Just(json)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            })
//            .map({ (data: Data, response: URLResponse) in
//                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
//                    return Fail(error: APIError.cannotDeserialiseJson).eraseToAnyPublisher()
//                }
//                return Just(json).eraseToAnyPublisher()
//            })
//            .mapError({ _ in
//                APIError.invalidUrl
//            })
            .eraseToAnyPublisher()
    }
    
//    private func publisher2(_ val: String) -> AnyPublisher<String, Error> {
//        let subject = PassthroughSubject<Int, Error>()
//        subject.send("\(val)2")
//        return subject.eraseToAnyPublisher()
//    }
    
    func testTrialRun() {
        let expectation = self.expectation(description: "testSubscribingWhenEmpty")
        test(urlString: "htts://asia-southeast2-macredditbackend.cloudfunctions.net/reddit/v1/api/subreddits/search.json?raw_json=1&q=Gunners&after&sort=&include_over_18=1&limit=1")
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("FinalSinkError: \(err)")
                case .finished:
                    print("done")
                }
                expectation.fulfill()
            } receiveValue: { value in
                print(value)
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5)
    }
}

