import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var speciesLabel: UILabel!
    
    private let imageCache = NSCache<NSString, UIImage>()
    private var currentImageURL: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil 
        speciesLabel.text = nil
        currentImageURL = nil
    }
    
    private func setupUI() {
        characterImageView.layer.cornerRadius = 8
        characterImageView.clipsToBounds = true
        characterImageView.contentMode = .scaleAspectFill
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        statusLabel.text = character.status.rawValue.capitalized
        speciesLabel.text = character.species
        
        loadImage(from: character.image)
        
        switch character.status {
        case .alive:
            statusLabel.textColor = .systemGreen
        case .dead:
            statusLabel.textColor = .systemRed
        default:
            statusLabel.textColor = .systemGray
        }
    }
    
    private func loadImage(from urlString: String) {
        currentImageURL = urlString
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            characterImageView.image = cachedImage
            return
        }
        
        guard let imageURL = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, _ in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  self.currentImageURL == urlString else { return }
            
            self.imageCache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                self.characterImageView.image = image
            }
        }.resume()
    }
}
