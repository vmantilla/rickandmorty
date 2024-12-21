import XCTest
@testable import RickAndMorthy

final class RickAndMortyAPIServiceTests: XCTestCase {
    var apiService: RickAndMortyAPIService!
    var mockSession: URLSessionMock!

    override func setUp() {
        super.setUp()
        mockSession = URLSessionMock()
        apiService = RickAndMortyAPIService(session: mockSession)
    }

    override func tearDown() {
        apiService = nil
        mockSession = nil
        super.tearDown()
    }

    func testFetchCharactersSuccess() {
        let mockData = """
        {
            "info": { "count": 1, "pages": 1, "next": null, "prev": null },
            "results": [
                { "id": 1, "name": "Rick Sanchez", "status": "Alive", "species": "Human", "gender": "Male", "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg" }
            ]
        }
        """.data(using: .utf8)

        mockSession.data = mockData

        let expectation = self.expectation(description: "Fetch Characters Success")
        apiService.fetchCharacters(page: 1, filter: nil) { result in
            switch result {
            case .success(let characters):
                XCTAssertEqual(characters.count, 1)
                XCTAssertEqual(characters.first?.name, "Rick Sanchez")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchCharactersFailure() {
        mockSession.error = NSError(domain: "TestError", code: 1, userInfo: nil)

        let expectation = self.expectation(description: "Fetch Characters Failure")
        apiService.fetchCharacters(page: 1, filter: nil) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
}
