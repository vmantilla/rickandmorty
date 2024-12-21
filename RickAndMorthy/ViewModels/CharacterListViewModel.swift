import Foundation

final class CharacterListViewModel {
    private let apiService: APIServiceProtocol
    private var currentPage: Int = 1
    private var isFetching: Bool = false
    private(set) var hasMorePages: Bool = true
    
    private(set) var characters: [Character] = []
    private(set) var appliedFilters: FilterOptions?
    private var searchTimer: Timer?
    
    var isLoading: Bool { isFetching }
    var onDataFetched: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func fetchCharacters(reset: Bool = false, filters: FilterOptions? = nil) {
        guard !isFetching else { return }
        
        if reset {
            currentPage = 1
            characters = []
            hasMorePages = true
            appliedFilters = filters
        }
        
        fetchNextPage()
    }
    
    private func handleFetchResult(_ result: Result<[Character], Error>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isFetching = false
            self.onLoading?(false)
            
            switch result {
            case .success(let newCharacters):
                if newCharacters.isEmpty {
                    self.hasMorePages = false
                } else {
                    if self.currentPage == 1 {
                        self.characters = newCharacters
                    } else {
                        self.characters.append(contentsOf: newCharacters)
                    }
                    self.currentPage += 1
                    self.onDataFetched?()
                }
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    func fetchNextPage() {
        guard !isFetching && hasMorePages else { return }
        
        isFetching = true
        onLoading?(true)
        
        apiService.fetchCharacters(page: currentPage, filter: appliedFilters, completion: handleFetchResult)
    }
    
    func searchCharacters(query: String) {
        searchTimer?.invalidate()
        
        if query.isEmpty {
            fetchCharacters(reset: true)
            return
        }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.performSearch(query: query)
        }
    }
    
    private func performSearch(query: String) {
        guard !isFetching else { return }
        
        isFetching = true
        onLoading?(true)
        currentPage = 1
        characters = []
        
        let searchFilter = FilterOptions(name: query, status: appliedFilters?.status, gender: appliedFilters?.gender)
        appliedFilters = searchFilter
        
        apiService.fetchCharacters(page: currentPage, filter: searchFilter, completion: handleFetchResult)
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        characters = []
        currentPage = 1
        hasMorePages = true
        appliedFilters = nil
        searchTimer?.invalidate()
        searchTimer = nil
        apiService.logout { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
