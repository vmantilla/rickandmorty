import Foundation

final class RickAndMortyAPIService: APIServiceProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private func performRequest<T: Decodable>(_ url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Error de decodificación: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchCharacters(page: Int, filter: FilterOptions?, completion: @escaping (Result<[Character], Error>) -> Void) {
        let url: URL?
        
        if let filter = filter {
            url = APIEndpoint.characterFilter(page: page, filter: filter).url
        } else {
            url = APIEndpoint.characters(page: page).url
        }
        
        guard let requestURL = url else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        performRequest(requestURL) { (result: Result<CharacterAPIResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCharacterDetails(id: Int, completion: @escaping (Result<Character, Error>) -> Void) {
        guard let url = APIEndpoint.characterDetail(id: id).url else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        performRequest(url, completion: completion)
    }
    
    func login(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if username.lowercased() == "rick" && password.lowercased() == "morty" {
                let token = UUID().uuidString
                UserDefaults.standard.set(token, forKey: "userToken")
                UserDefaults.standard.synchronize()
                
                completion(.success(()))
            } else {
                let error = NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid username or password"])
                completion(.failure(error))
            }
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().async {
            UserDefaults.standard.removeObject(forKey: "userToken")
            UserDefaults.standard.synchronize()
            completion(.success(()))
        }
    }
}
