import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loadingSpinner: UIActivityIndicatorView!
    
    private let viewModel = LoginViewModel(apiService: RickAndMortyAPIService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        title = "Login"
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupBindings() {
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            if isLoading {
                self?.loadingSpinner.startAnimating()
            } else {
                self?.loadingSpinner.stopAnimating()
            }
        }
        
        viewModel.onLoginSuccess = { [weak self] in
            self?.usernameTextField.text = ""
            self?.passwordTextField.text = ""
            
            let characterListVC = CharacterListViewController()
            let navigationController = UINavigationController(rootViewController: characterListVC)
            navigationController.modalPresentationStyle = .fullScreen
            self?.present(navigationController, animated: true)
        }
        
        viewModel.onLoginError = { [weak self] error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    @IBAction private func loginButtonTapped() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        viewModel.login(username: username, password: password)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
}
