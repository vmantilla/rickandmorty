import Foundation

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead" 
    case unknown = "Unknown"
    case none = ""
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self).lowercased()
        
        switch rawValue {
        case "alive": self = .alive
        case "dead": self = .dead
        case "unknown": self = .unknown
        default: self = .none
        }
    }
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "Unknown"
    case none = ""
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self).lowercased()
        
        switch rawValue {
        case "female": self = .female
        case "male": self = .male
        case "genderless": self = .genderless
        case "unknown": self = .unknown
        default: self = .none
        }
    }
}

struct Location: Codable {
    let name: String
    let url: String
}

struct Character: Codable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String?
    let gender: Gender
    let origin: Location?
    let location: Location?
    let image: String
    let episode: [String]?
    let url: String?
    let created: String?
    
    init(id: Int, name: String, status: Status = .none, species: String, type: String? = nil, 
         gender: Gender = .none, origin: Location? = nil, location: Location? = nil, 
         image: String, episode: [String]? = nil, url: String? = nil, created: String? = nil) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
        self.url = url
        self.created = created
    }
}
