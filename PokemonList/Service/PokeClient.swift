import Alamofire

protocol Client {
    func requestPokemonList(url: String?, completion: @escaping (PokemonListModel) -> Void)
}

class PokeClient: Client {
    func requestPokemonList(url: String?, completion: @escaping (PokemonListModel) -> Void) {
        let requestURL: String = url ?? Constants.pokemonListURL
        AF.request(requestURL)
            .responseDecodable(of: PokemonListModel.self) { response in
                switch response.result {
                case .success(let pokeListModel):
                    completion(pokeListModel)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
