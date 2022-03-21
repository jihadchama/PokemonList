@testable import PokemonList

class MockPokeClient: Client {
    var shouldRequestFails: Bool = false
    
    func requestPokemonList(url: String?, completion: @escaping (PokemonListModel) -> Void) {
        if !shouldRequestFails {
            completion(PokemonListModel(next: "xpto", results: [PokemonModel(name: "xpto", url: "xpto")]))
        }
    }
}
