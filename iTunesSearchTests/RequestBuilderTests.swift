//
//  RequestBuilderTests.swift
//  iTunesSearchTests
//
//  Created by Vlad Boguzh on 17.04.2024.
//

import XCTest
@testable import iTunesSearch

final class RequestBuilderTests: XCTestCase {

    var requestBuilder: RequestBuilder!

    override func setUp() {
        super.setUp()
        requestBuilder = RequestBuilderImpl()
    }

    override func tearDown() {
        requestBuilder = nil
        super.tearDown()
    }

    func testBuild() {
        let mockRequest = MockNetworkRequest()
        let urlRequest = requestBuilder.build(request: mockRequest)
        print(urlRequest.timeoutInterval)
        XCTAssertEqual(
            urlRequest.url,
            mockRequest.baseURL
                .appendingPathComponent(mockRequest.path)
                .appending(queryItems: mockRequest.queryItems)
        )
        XCTAssertEqual(urlRequest.httpMethod, mockRequest.httpMethod.rawValue)
        XCTAssertEqual(urlRequest.timeoutInterval, mockRequest.timeoutInterval)
    }
}
