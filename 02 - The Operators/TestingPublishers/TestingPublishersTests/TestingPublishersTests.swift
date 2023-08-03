//
//  TestingPublishersTests.swift
//  TestingPublishersTests
//
//  Created by Vincent on 03/08/2023.
//

import Combine
import XCTest
@testable import TestingPublishers

final class TestingPublishersTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func testEvenNumbersPublisher() {
        var values: [Int] = []
        
        let expectation = self.expectation(description: "Even Number Publisher has finished")
        
        let sut = evenNumbersPublisher()
                
        sut
            .sink { _ in
                expectation.fulfill()
            } receiveValue: { value in
                values.append(value)
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssert(values.allSatisfy { $0.isMultiple(of: 2) })
    }
    
    func testOddNumbersPublisher() throws {
        let sut = oddNumbersPublisher()
        
        let values = try awaitPublisher(sut)
        
        XCTAssert(values.allSatisfy { $0.isMultiple(of: 2) == false })
    }
}

extension XCTestCase {
    func awaitPublisher<P: Publisher>(
        _ publisher: P,
        timeout: TimeInterval = 10,
        testName: StaticString = #function
    ) throws -> [P.Output] {
        var values: [P.Output] = []
        var reportedError: Error?
        
        let expectation = self.expectation(description: "Awaiting publisher in test \(testName)")
        
        let cancellable = publisher.sink { completion in
            switch completion {
            case .failure(let error):
                reportedError = error
            case .finished:
                break
            }
            
            expectation.fulfill()
        } receiveValue: { value in
            values.append(value)
        }
        
        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        if let reportedError {
            throw reportedError
        }
        
        return values
    }
}
