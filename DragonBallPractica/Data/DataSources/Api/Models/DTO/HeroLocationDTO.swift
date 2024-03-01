import Foundation

struct HeroLocationDTO {
    let id: String?
    let latidude: String?
    let longitude: String?
    let dateShow: String?
    let heroId: String?
}

extension HeroLocationDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case latitude = "latitud"
        case longitude = "longitud"
        case dateShow
        case id
        case hero
    }
    
    enum HeroContainer: String, CodingKey {
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let heroContainer = try container.nestedContainer(keyedBy: HeroContainer.self, forKey: .hero)
        
        latidude = try container.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        dateShow = try container.decodeIfPresent(String.self, forKey: .dateShow)
        heroId = try heroContainer.decodeIfPresent(String.self, forKey: .id)
    }
}
