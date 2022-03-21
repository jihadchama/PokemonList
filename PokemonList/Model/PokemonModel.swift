struct PokemonModel: Codable {
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}
