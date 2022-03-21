import UIKit

protocol PokeListViewModel {
    var pokemons: [PokemonModel] { get }
    var pokeListLiveData: LiveData<PokemonListModel> { get }
    
    init(client: Client)
    
    func requestPokemons()
    func update(with pokemonList: PokemonListModel)
    func didChoosePokemon(with pokemon: PokemonModel?)
}

class PokeListViewModelImpl: PokeListViewModel {
    private let pokeListMutableLiveData = MutableLiveData<PokemonListModel>()
    private let pokeClient: Client
    
    var pokemons = [PokemonModel]()
    
    required init(client: Client) {
        pokeClient = client
    }
    
    var pokeListLiveData: LiveData<PokemonListModel> {
        return pokeListMutableLiveData
    }
    
    func requestPokemons() {
        pokeClient.requestPokemonList(url: pokeListLiveData.value?.next) { self.update(with: $0) }
    }
    
    func update(with pokemonList: PokemonListModel) {
        self.pokemons.append(contentsOf: pokemonList.results)
        let newPokemonList = PokemonListModel(next: pokemonList.next, results: self.pokemons)
        pokeListMutableLiveData.value = newPokemonList
    }
    
    func didChoosePokemon(with pokemon: PokemonModel?) {
        guard let pokemon = pokemon, let url = URL(string: pokemon.url) else { return }
        UIApplication.shared.open(url)
    }
}
