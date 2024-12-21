import Foundation

final class CharacterDetailsViewModel {
    private let apiService: APIServiceProtocol
    private(set) var character: Character?
    
    var onDataFetched: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    init(apiService: APIServiceProtocol, character: Character? = nil) {
        self.apiService = apiService
        self.character = character
    }
    
    func fetchCharacterDetails(id: Int) {
        onLoading?(true)
        apiService.fetchCharacterDetails(id: id) { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoading?(false)
                switch result {
                case .success(let character):
                    self?.character = character
                    self?.onDataFetched?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}
