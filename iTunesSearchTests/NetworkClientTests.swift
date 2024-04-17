//
//  NetworkClientTests.swift
//  iTunesSearchTests
//
//  Created by Vlad Boguzh on 18.04.2024.
//

import XCTest
@testable import iTunesSearch

// swiftlint:disable force_unwrapping
final class NetworkClientTests: XCTestCase {

    var networkClient: NetworkClient!
    var urlSession: URLSession!

    override func setUp() {
        super.setUp()

        urlSession = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.protocolClasses = [MockURLProtocol.self]
            return URLSession(configuration: configuration)
        }()

        networkClient = NetworkClientImpl(urlSession: urlSession)
    }

    override func tearDown() {
        urlSession = nil
        networkClient = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func testSuccess() async {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "MockResponseSuccess", withExtension: "json") else {
            XCTFail("Missing file: MockResponseSuccess.json")
            return
        }
        guard let mockData = try? Data(contentsOf: url) else {
            XCTFail("Can't create mock data from url")
            return
        }
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockData)
        }
        guard let result = try? await networkClient.send(request: MockNetworkRequest()) else {
            XCTFail("The request finished with unexpected error")
            return
        }
        XCTAssertEqual(result.resultCount, 2)
        XCTAssertEqual(result.results[0], MockNetworkResponse.FullName(firstName: "Tim", secondName: "Cook"))
        XCTAssertEqual(result.results[1], MockNetworkResponse.FullName(firstName: "Steve", secondName: "Jobs"))
    }

    func testBadResponseFailure() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        do {
            _ = try await networkClient.send(request: MockNetworkRequest())
        } catch let error as NetworkError {
            XCTAssertEqual(error, .badResponse)
        } catch {
            XCTFail("Unexpected type of error")
        }
    }

    func testDecodingFailure() async {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "MockResponseMissingField", withExtension: "json") else {
            XCTFail("Missing file: MockResponseMissingField.json")
            return
        }
        guard let mockData = try? Data(contentsOf: url) else {
            XCTFail("Can't create mock data from url")
            return
        }
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockData)
        }
        do {
            _ = try await networkClient.send(request: MockNetworkRequest())
            XCTFail("The send request should fail")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .parsingFailure)
        } catch {
            XCTFail("Unexpected type of error")
        }
    }

    func testTimeoutFailure() async {
        MockURLProtocol.error = URLError(.timedOut)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        do {
            _ = try await networkClient.send(request: MockNetworkRequest())
            XCTFail("The send request should fail")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .timeout)
        } catch {
            XCTFail("Unexpected type of error")
        }
    }
}
// swiftlint:enable force_unwrapping
