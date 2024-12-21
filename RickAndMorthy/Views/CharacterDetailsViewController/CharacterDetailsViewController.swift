import UIKit

class CharacterDetailsViewController: UIViewController {
    
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var speciesLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var originLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    
    private let viewModel: CharacterDetailsViewModel
    
    init(viewModel: CharacterDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = CharacterDetailsViewModel(apiService: RickAndMortyAPIService())
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupUI()
    }
    
    private func setupBindings() {
        viewModel.onDataFetched = { [weak self] in
            self?.setupUI()
        }
        
        viewModel.onError = { [weak self] error in
            print("Error: \(error)")
        }
        
        viewModel.onLoading = { [weak self] isLoading in
        }
    }
    
    func configure(with character: Character) {
        let newViewModel = CharacterDetailsViewModel(apiService: RickAndMortyAPIService(), character: character)
        viewModel.fetchCharacterDetails(id: character.id)
        if isViewLoaded {
            setupUI()
        }
    }
    
    private func setupUI() {
        guard let character = viewModel.character else { return }
        
        title = character.name
        nameLabel.text = character.name
        statusLabel.text = "Status: \(character.status.rawValue)"
        speciesLabel.text = "Species: \(character.species)"
        genderLabel.text = "Gender: \(character.gender.rawValue)"
        originLabel.text = "Origin: \(character.origin?.name ?? "Unknown")"
        locationLabel.text = "Location: \(character.location?.name ?? "Unknown")"
        
        if let type = character.type, !type.isEmpty {
            typeLabel.text = "Type: \(type)"
            typeLabel.isHidden = false
        } else {
            typeLabel.isHidden = true
        }
        
        if let imageUrl = URL(string: character.image) {
            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, error in
                if let error = error {
                    print("Error loading image: \(error)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.characterImageView.image = image
                    }
                }
            }.resume()
        }
        
        switch character.status {
        case .alive:
            statusLabel.textColor = .systemGreen
        case .dead:
            statusLabel.textColor = .systemRed
        default:
            statusLabel.textColor = .systemGray
        }
    }
}
