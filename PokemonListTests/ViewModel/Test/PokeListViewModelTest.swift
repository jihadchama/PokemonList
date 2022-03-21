import XCTest
@testable import PokemonList

class PokeListViewModelTest: XCTestCase {
    
    var mockPokeClient: MockPokeClient!
    var sut: PokeListViewModelImpl!
    
    override func setUp() {
        mockPokeClient = MockPokeClient()
        sut = PokeListViewModelImpl(client: mockPokeClient)
    }
    
    override func tearDown() {
        mockPokeClient = nil
        sut = nil
    }

    func test_ShouldUpdatePokemonList_WhenSuccessfullyRequested() {
        sut.requestPokemons()
        
        XCTAssertNotNil(sut.pokeListLiveData.value)
    }
    
    func test_ShouldntUpdatePokemonList_WhenRequestFailed() {
        mockPokeClient.shouldRequestFails = true
        sut.requestPokemons()
        
        XCTAssertNil(sut.pokeListLiveData.value)
    }
    
    func test_ShouldUpdatePokemonList_WhenUpdateMethodCalled() {
        sut.update(with: PokemonListModel(next: "xpto",
                                          results: [PokemonModel(name: "xpto", url: "xpto")]))
        
        XCTAssertNotNil(sut.pokeListLiveData.value)
    }
    
    func test_ShouldAppendPokemonsInPokemonList_WhenPaginate() {
        sut.requestPokemons()
        sut.requestPokemons()
        
        XCTAssertNotNil(sut.pokeListLiveData.value)
        XCTAssertEqual(sut.pokeListLiveData.value?.results.count, 2)
    }
    
    func test_ShouldChangeNextPageURL_WhenPaginate() {
        sut.requestPokemons()
        sut.update(with: PokemonListModel(next: "page2",
                                          results: [PokemonModel(name: "xpto", url: "xpto")]))
        
        XCTAssertNotNil(sut.pokeListLiveData.value)
        XCTAssertEqual(sut.pokeListLiveData.value?.results.count, 2)
        XCTAssertEqual(sut.pokeListLiveData.value?.next, "page2")
    }
}
