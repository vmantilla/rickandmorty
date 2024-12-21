import UIKit

class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "morty")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigateToMainScreen()
    }
    
    private func setupImage() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        ])
    }
    
    private func navigateToMainScreen() {
        let workItem = DispatchWorkItem { [weak self] in
            if let userToken = UserDefaults.standard.string(forKey: "userToken"), !userToken.isEmpty {
                let characterListVC = CharacterListViewController(nibName: "CharacterListViewController", bundle: nil)
                let navigationController = UINavigationController(rootViewController: characterListVC)
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.isNavigationBarHidden = true
                self?.present(navigationController, animated: true)
            } else {
                let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
                loginVC.modalPresentationStyle = .fullScreen
                self?.present(loginVC, animated: true)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: workItem)
    }

}
