struct PokemonListModel: Codable {
    let next: String
    var results: [PokemonModel]
    
    enum CodingKeys: String, CodingKey {
        case next
        case results
    }
}
