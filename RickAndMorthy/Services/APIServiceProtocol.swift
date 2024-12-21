import Foundation

protocol APIServiceProtocol {
    func fetchCharacters(page: Int, filter: FilterOptions?, completion: @escaping (Result<[Character], Error>) -> Void)
    func fetchCharacterDetails(id: Int, completion: @escaping (Result<Character, Error>) -> Void)
    func login(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
}
