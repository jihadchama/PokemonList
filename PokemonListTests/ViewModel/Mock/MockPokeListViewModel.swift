@testable import PokemonList

class MockPokeListViewModel: PokeListViewModel {
    var pokemons: [PokemonModel] = [PokemonModel]()
    
    private let client: Client
    
    private var mockPokeListMutableLiveData = MutableLiveData<PokemonListModel>()
    
    var didChoosePokemon: Bool = false
    
    var pokeListLiveData: LiveData<PokemonListModel> {
        mockPokeListMutableLiveData
    }
    
    required init(client: Client) {
        self.client = client
    }
    
    func requestPokemons() {
        client.requestPokemonList(url: "xpto") { self.update(with: $0) }
    }
    
    func update(with pokemonList: PokemonListModel) {
        self.pokemons.append(contentsOf: pokemonList.results)
        let newPokemonList = PokemonListModel(next: pokemonList.next, results: self.pokemons)
        mockPokeListMutableLiveData.value = newPokemonList
    }
    
    func didChoosePokemon(with pokemon: PokemonModel?) {
        self.didChoosePokemon = true
    }
}
