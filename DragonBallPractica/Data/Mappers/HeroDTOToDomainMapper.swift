import Foundation

struct HeroDTOToDomainMapper: HeroDTOToDomainMapperProtocol {
    func map(_ heroDTO: HeroDTO) -> Hero? {
        guard let id = heroDTO.id else { return nil }
        
        var photoUrlComponents = URLComponents(string: heroDTO.photo ?? "")
        photoUrlComponents?.scheme = "https"
        
        return Hero(
            id: id,
            name: heroDTO.name ?? "",
            isFavorite: heroDTO.favorite ?? false,
            photo: photoUrlComponents?.string,
            description: heroDTO.description
        )
    }
}
