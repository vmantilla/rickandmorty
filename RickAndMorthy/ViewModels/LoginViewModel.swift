import Foundation

class LoginViewModel {
    private let apiService: APIServiceProtocol
    
    var isLoading: Bool = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onLoginSuccess: (() -> Void)?
    var onLoginError: ((Error) -> Void)?
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func login(username: String, password: String) {
        isLoading = true
        
        apiService.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.onLoginSuccess?()
                case .failure(let error):
                    self?.onLoginError?(error)
                }
            }
        }
    }
}
