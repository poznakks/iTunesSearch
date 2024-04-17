//
//  iTunesSearchTests.swift
//  iTunesSearchTests
//
//  Created by Vlad Boguzh on 17.04.2024.
//

import XCTest
@testable import iTunesSearch

// swiftlint:disable line_length
final class JsonMappingTests: XCTestCase {

    func testTrackMapping() {
        let expectedResponse = MediaResponse(
            resultCount: 1,
            results: [
                Media(
                    wrapperType: .track,
                    kind: .song,
                    collectionType: nil,
                    artistType: nil,
                    artistId: 966309175,
                    collectionId: 1477880265,
                    trackId: 1477880568,
                    artistName: "Post Malone",
                    collectionName: "Hollywood's Bleeding",
                    trackName: "Take What You Want (feat. Ozzy Osbourne & Travis Scott)",
                    artistViewUrl: URL(
                        string: "https://music.apple.com/us/artist/post-malone/966309175?uo=4"
                    ),
                    collectionViewUrl: URL(
                        string: "https://music.apple.com/us/album/take-what-you-want-feat-ozzy-osbourne-travis-scott/1477880265?i=1477880568&uo=4"
                    ),
                    trackViewUrl: URL(
                        string: "https://music.apple.com/us/album/take-what-you-want-feat-ozzy-osbourne-travis-scott/1477880265?i=1477880568&uo=4"
                    ),
                    artistLinkUrl: nil,
                    artworkUrl100: URL(
                        string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/7b/1b/1b/7b1b1b0b-7ce2-b223-f9e0-8e36abe51877/19UMGIM78325.rgb.jpg/100x100bb.jpg"
                    ),
                    collectionPrice: 9.99,
                    trackPrice: 1.29,
                    trackTimeMillis: 229580,
                    country: "USA",
                    currency: "USD",
                    primaryGenreName: "Hip-Hop/Rap",
                    longDescription: nil,
                    contentAdvisoryRating: nil
                )
            ]
        )
        testMediaMapping(fileName: "MockTrack", expectedResponse: expectedResponse)
    }

    func testCollectionMapping() {
        let expectedResponse = MediaResponse(
            resultCount: 1,
            results: [
                Media(
                    wrapperType: .collection,
                    kind: nil,
                    collectionType: "Album",
                    artistType: nil,
                    artistId: 29254083,
                    collectionId: 1273787064,
                    trackId: nil,
                    artistName: "Miguel",
                    collectionName: "Sky Walker (feat. Travis Scott) - Single",
                    trackName: nil,
                    artistViewUrl: URL(
                        string: "https://music.apple.com/us/artist/miguel/29254083?uo=4"
                    ),
                    collectionViewUrl: URL(
                        string: "https://music.apple.com/us/album/sky-walker-feat-travis-scott-single/1273787064?uo=4"
                    ),
                    trackViewUrl: nil,
                    artistLinkUrl: nil,
                    artworkUrl100: URL(
                        string: "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/ae/4a/6e/ae4a6e8b-d8df-7f06-db7b-3e923ba51756/886446674513.jpg/100x100bb.jpg"
                    ),
                    collectionPrice: 1.29,
                    trackPrice: nil,
                    trackTimeMillis: nil,
                    country: "USA",
                    currency: "USD",
                    primaryGenreName: "R&B/Soul",
                    longDescription: nil,
                    contentAdvisoryRating: "Explicit"
                )
            ]
        )
        testMediaMapping(fileName: "MockCollection", expectedResponse: expectedResponse)
    }

    func testArtistMapping() {
        let expectedResponse = MediaResponse(
            resultCount: 1,
            results: [
                Media(
                    wrapperType: .artist,
                    kind: nil,
                    collectionType: nil,
                    artistType: "Artist",
                    artistId: 549236696,
                    collectionId: nil,
                    trackId: nil,
                    artistName: "Travis Scott",
                    collectionName: nil,
                    trackName: nil,
                    artistViewUrl: nil,
                    collectionViewUrl: nil,
                    trackViewUrl: nil,
                    artistLinkUrl: URL(
                        string: "https://music.apple.com/us/artist/travis-scott/549236696?uo=4"
                    ),
                    artworkUrl100: nil,
                    collectionPrice: nil,
                    trackPrice: nil,
                    trackTimeMillis: nil,
                    country: nil,
                    currency: nil,
                    primaryGenreName: "Hip-Hop/Rap",
                    longDescription: nil,
                    contentAdvisoryRating: nil
                )
            ]
        )
        testMediaMapping(fileName: "MockArtist", expectedResponse: expectedResponse)
    }

    private func testMediaMapping(fileName: String, expectedResponse: MediaResponse) {
        let bundle = Bundle(for: type(of: self))

        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("Missing file: \(fileName).json")
            return
        }

        guard let json = try? Data(contentsOf: url) else {
            XCTFail("Can't create json from url")
            return
        }

        guard let decodedJson = try? JSONDecoder().decode(MediaResponse.self, from: json) else {
            XCTFail("Can't decode json")
            return
        }

        XCTAssertEqual(decodedJson, expectedResponse)
    }
}
// swiftlint:enable line_length
