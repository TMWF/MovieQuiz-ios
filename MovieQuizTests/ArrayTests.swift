//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Leo Bonhart on 29.12.2022.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
//         Given
        let array = [1, 2, 3, 4, 5]
//         When
        let result = array[safe: 2]
//        Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 3)
    }
    
    func testGetValueOutOfRange() throws {
//         Given
        let array = [1, 2, 3, 4, 5]
//         When
        let result = array[safe: 5]
//        Then
        XCTAssertNil(result)
    }
}
