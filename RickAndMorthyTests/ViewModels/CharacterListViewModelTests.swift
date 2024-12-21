import XCTest
@testable import RickAndMorthy

final class CharacterListViewModelTests: XCTestCase {
    var viewModel: CharacterListViewModel!
    var mockService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
        viewModel = CharacterListViewModel(apiService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testFetchCharactersSuccess() {
        let mockCharacters = [
            Character(id: 1, name: "Rick Sanchez", status: Status.alive, species: "Human", gender: Gender.male, image: "")
        ]
        mockService.mockCharactersResult = .success(mockCharacters)

        let expectation = self.expectation(description: "Fetch Characters Success")
        viewModel.onDataFetched = {
            XCTAssertEqual(self.viewModel.characters.count, 1)
            XCTAssertEqual(self.viewModel.characters.first?.name, "Rick Sanchez")
            expectation.fulfill()
        }

        viewModel.fetchCharacters(reset: true)
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchCharactersFailure() {
        mockService.mockCharactersResult = .failure(NSError(domain: "TestError", code: 1, userInfo: nil))

        let expectation = self.expectation(description: "Fetch Characters Failure")
        viewModel.onError = { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        viewModel.fetchCharacters(reset: true)
        waitForExpectations(timeout: 2, handler: nil)
    }
}
