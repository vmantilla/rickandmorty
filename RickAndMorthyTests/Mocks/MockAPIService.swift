import Foundation
@testable import RickAndMorthy

final class MockAPIService: APIServiceProtocol {
    var mockLoginResult: Result<Void, Error>?
    var mockCharactersResult: Result<[Character], Error>?
    var mockCharacterDetailsResult: Result<Character, Error>?
    var mockLogoutResult: Result<Void, Error>?
    
    var loginCalled = false
    var logoutCalled = false
    var fetchCharactersCalled = false
    var fetchCharacterDetailsCalled = false
    
    var lastUsername: String?
    var lastPassword: String?
    var lastPage: Int?
    var lastFilter: FilterOptions?
    var lastCharacterId: Int?

    func login(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        loginCalled = true
        lastUsername = username
        lastPassword = password
        if let result = mockLoginResult {
            completion(result)
        }
    }

    func fetchCharacters(page: Int, filter: FilterOptions?, completion: @escaping (Result<[Character], Error>) -> Void) {
        fetchCharactersCalled = true
        lastPage = page
        lastFilter = filter
        if let result = mockCharactersResult {
            completion(result)
        }
    }
    
    func fetchCharacterDetails(id: Int, completion: @escaping (Result<Character, Error>) -> Void) {
        fetchCharacterDetailsCalled = true
        lastCharacterId = id
        if let result = mockCharacterDetailsResult {
            completion(result)
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        logoutCalled = true
        if let result = mockLogoutResult {
            completion(result)
        }
    }
}
