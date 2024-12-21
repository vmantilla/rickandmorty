import Foundation

enum APIEndpoint {
    private static let baseURL = "https://rickandmortyapi.com/api"
    
    case characters(page: Int)
    case characterFilter(page: Int, filter: FilterOptions)
    case characterDetail(id: Int)
    
    var url: URL? {
        switch self {
        case .characters(let page):
            return buildURL(path: "/character", queryItems: [
                URLQueryItem(name: "page", value: "\(page)")
            ])
            
        case .characterFilter(let page, let filter):
            var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
            
            if let name = filter.name, !name.isEmpty {
                queryItems.append(URLQueryItem(name: "name", value: name))
            }
            if let status = filter.status, !status.isEmpty {
                queryItems.append(URLQueryItem(name: "status", value: status))
            }
            if let species = filter.species, !species.isEmpty {
                queryItems.append(URLQueryItem(name: "species", value: species))
            }
            if let type = filter.type, !type.isEmpty {
                queryItems.append(URLQueryItem(name: "type", value: type))
            }
            if let gender = filter.gender, !gender.isEmpty {
                queryItems.append(URLQueryItem(name: "gender", value: gender))
            }
            
            return buildURL(path: "/character", queryItems: queryItems)
            
        case .characterDetail(let id):
            return buildURL(path: "/character/\(id)", queryItems: [])
        }
    }
    
    private func buildURL(path: String, queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents(string: APIEndpoint.baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
}
